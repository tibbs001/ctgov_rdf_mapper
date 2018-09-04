java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.query.QueryFactory'
java_import 'com.hp.hpl.jena.query.QueryExecutionFactory'
java_import 'com.hp.hpl.jena.query.ResultSetFormatter'
java_import 'com.hp.hpl.jena.sparql.core.Quad'

module VivoMapper
  class ImportManager

    attr_reader :config, :logger

    def initialize(config,logger=nil)
      @config = config
      @logger = logger
    end
 
    def simple_import(name, resources=[],dest_model_name=@config.destination_model_name, map_type='Regular',store_type=:sdb)
      name = "Inferred_#{name}" if map_type != 'Regular'
      load_resources(name, resources, map_type)
      store(dest_model_name, 'destination',store_type) do |destination_model|
        store(name, 'incoming') do |incoming_model|
          store(name, 'staging') do |staging_model|
            loader = VivoMapper::SimpleLoader.new(staging_model, destination_model, logger)
            loader.add_model(incoming_model)
          end
        end
      end
    end

    def difference_import(name, resources=[], dest_model_name=@config.destination_model_name, map_type='Regular', store_type=:sdb)
      name = "Inferred_#{name}" if map_type != 'Regular'
      load_resources(name, resources, map_type)
      store(dest_model_name, 'destination',store_type) do |destination_model|
        store(name, 'incoming') do |incoming_model|
          store(name, 'staging') do |staging_model|
            loader = VivoMapper::DifferenceLoader.new(staging_model,destination_model, logger)
            loader.import_model(incoming_model)
          end
        end
      end
    end

    def individual_difference_import(duid, name, resources=[], dest_model_name=@config.destination_model_name, map_type='Regular', store_type=:sdb)
      load_model_name = map_type != 'Regular' ? "Inferred_#{name}" : name
      load_resources(load_model_name, resources, map_type)
      store(dest_model_name, 'destination',store_type) do |destination_model|
        store(load_model_name, 'incoming') do |incoming_model|
          store(load_model_name, 'staging') do |staging_model|
            loader = VivoMapper::DifferenceLoader.new(staging_model,destination_model, logger)
            map_obj = eval "VivoMapper::#{name}.new.mapping"
            person  = eval "VivoMapper::Person.new(:uid => '#{duid}')"
            person_uri = person.mapping.uri(@config.namespace,person)
            diff_model = map_obj.graph_for(person_uri, staging_model, map_type)
            loader.import_model(incoming_model, diff_model)
          end
        end
      end
    end

    def simple_removal(name, resources=[], dest_model_name=@config.destination_model_name, map_type='Regular', store_type=:sdb)
      load_resources(name, resources, map_type)
      store(@config.destination_model_name, 'destination',store_type) do |destination_model|
        store(name, 'incoming') do |incoming_model|
          store(name, 'staging') do |staging_model|
            loader = VivoMapper::SimpleLoader.new(staging_model, destination_model, logger)
            loader.remove_model(incoming_model)
          end
        end
      end
    end

    def graph_for(duid, model_name, name, resources=[], map_type='Regular')
      graph_model = ModelFactory.create_default_model
      map_obj = eval "VivoMapper::#{name}.new.mapping"
      person  = eval "VivoMapper::Person.new(:uid => '#{duid}')"
      person_uri = person.mapping.uri(@config.namespace,person)

      store(model_name, 'staging') do |staging_model|
        item_query = QueryFactory.create(map_obj.staging_uris(person_uri));
        item_qexec = QueryExecutionFactory.create(item_query, staging_model);
        item_uris = item_qexec.execSelect();
        while item_uris.has_next do 
          item_uri = item_uris.next.get('?grant')
          sparql_constructs = map_obj.sparql_constructs(person_uri, item_uri, map_type)
          sparql_constructs.each do |sparql_construct|
            query = QueryFactory.create(sparql_construct);
            qexec = QueryExecutionFactory.create(query, staging_model);
            results = qexec.execConstruct();
            graph_model.add(results)
            qexec.close() ;
          end
        end
        item_qexec.close() ;
        puts "*************************"
        puts graph_model
        puts "*************************"
        graph_model
      end
    end

    def clear_staging(model_name)
      store(model_name, 'staging') do |staging_model|
        staging_model.remove_all
      end
    end

    def archive_destination_difference(archive_model_name=@config.destination_model_name, destination_model_name=@config.destination_model_name)
      # set name to config's destination_model_name (or allow pass-in ?)
      # truncate archive by name?
      # diff dest w/ union of staging for add change
      # put that model into archive
      store(archive_model_name, 'archive') do |archive_model|
        store(destination_model_name, 'destination') do |destination_model|
          union('staging') do |staging_union_model|
            destination_owned_add_change_model = destination_model.difference(staging_union_model)
            archive_model.remove_all
            archive_model.add(destination_owned_add_change_model)
          end
        end
      end
    end

    def archive_metadata(archive_model_name,destination_model_name=nil)
      archive_destination_model(:rdb,archive_model_name,destination_model_name)
    end

    def archive_destination_model(format, archive_model_name,destination_model_name=nil)
      destination_model_name ||= archive_model_name
      store(archive_model_name, 'archive') do |archive_model|
        store(destination_model_name, 'destination', format) do |destination_model|
          archive_model.remove_all
          archive_model.add(destination_model)
        end
      end
    end

    def restore_archived_metadata(archive_model_name,destination_model_name=nil)
      destination_model_name ||= archive_model_name
      store(archive_model_name, 'archive') do |archive_model|
        store(destination_model_name, 'destination', :rdb) do |destination_model|
          destination_model.remove_all
          destination_model.add(archive_model)
        end
      end
    end

    def load_resources(name, resources=[], map_type='Regular')
      truncate('incoming')
      store(name, 'incoming') do |model|
        mapper = VivoMapper::Mapper.new(config.namespace, model, config.ontology_model, map_type)
        resources.each do |r|
          mapper.map_resource(r)
        end
      end
    end

    def export(name, store_name, format=:sdb)
      store(name, store_name, format) do |model|
        model.write(java.lang.System.out)
      end
    end

    def truncate(store_name)
      config.send("#{store_name}_sdb").truncate
    end

    def differences_between(name, first_model_name, second_model_name)
      store(name, first_model_name) do |first|
        store(name, second_model_name) do |second|
          second.difference(first)
        end
      end
    end

    def size(name, s, format=:sdb)
      data_store(s, format).with_named_model(name) {|model| model.size }
    end

    def store(name, s, format=:sdb, &block)
      data_store(s, format).with_named_model(name) {|model| block.call(model) }
    end

    def union(s, format=:sdb, &block)
      data_store(s, format).with_union_model {|model| block.call(model) }
    end

    def data_store(s, format=:sdb)
      result = config.send("#{s}_sdb")
      if format == :rdb
        result = VivoMapper::RDB.from_sdb(result)
      end
      result
    end

    def get_from_staging(model_name, query_string, variable_name)
      results = [];
      return_results = [];
      store(model_name, 'staging') do |staging_model|
        query = QueryFactory.create(query_string);
        item_qexec = QueryExecutionFactory.create(query_string, staging_model);
        results = item_qexec.execSelect();
        while results.has_next do 
          return_results << results.next.get(variable_name).to_s
        end
      end
      return return_results;
    end

  end

end

