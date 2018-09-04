java_import 'com.hp.hpl.jena.sdb.sql.SDBConnection'
java_import 'com.hp.hpl.jena.query.DatasetFactory'
java_import 'com.hp.hpl.jena.sdb.SDBFactory'
java_import 'com.hp.hpl.jena.sdb.store.StoreFactory'
java_import 'com.hp.hpl.jena.sdb.StoreDesc'
java_import 'com.hp.hpl.jena.sdb.store.DatabaseType'
java_import 'com.hp.hpl.jena.sdb.store.LayoutType'
java_import 'com.hp.hpl.jena.sdb.util.StoreUtils'

module VivoMapper

  class SDB

    attr_reader :url, :username, :password, :driver_class_name, :db_type, :layout_type

    def initialize(url,username,password,driver_class_name,db_type,layout_type)
      @url, @username, @password, @driver_class_name, @db_type, @layout_type = url, username, password, driver_class_name, db_type, layout_type
    end

    def store_desc
      store_desc = StoreDesc.new(LayoutType.fetch(@layout_type),DatabaseType.fetch(@db_type))
    end

    def with_store(store_desc,connection,&block)
      store = StoreFactory.create(store_desc,connection)
      store.get_table_formatter.create unless StoreUtils.formatted(store)
      begin
        result = block.call(store)
      ensure
        store.close
      end
      result
    end

    def with_connection(&block)
      java_import @driver_class_name
      connection = SDBConnection.new(@url, @username, @password)
      begin
        result = block.call(connection)
      ensure
        connection.close
      end
      result
    end

    def with_dataset(&block)
      self.with_connection do |connection|
        dataset = DatasetFactory.create(SDBFactory.connect_dataset(connection,store_desc))
        begin
          result = block.call(dataset)
        ensure
          dataset.close
        end
        result
      end
    end

    def with_union_model(&block)
      model_names = with_dataset do |dataset|
        dataset.list_names.to_a
      end
      self.with_connection do |connection|
        self.with_store(store_desc, connection) do |store|
          models = model_names.collect{|model_name| SDBFactory.connect_named_model(store,model_name)}
          union_model = models.inject(ModelFactory.create_default_model){|acc,m| acc.union(m)}
          begin
            result = block.call(union_model)
          ensure
            models.each{|m| m.close}
          end
          result
        end
      end

    end

    def truncate
      self.with_connection do |connection|
        self.with_store(store_desc, connection) do |store|
          store.get_table_formatter.truncate
        end
      end
    end

    def size
      self.with_connection do |connection|
        self.with_store(store_desc, connection) do |store|
          store.get_size
        end
      end
    end


    def with_named_model(model_uri,&block)
      self.with_connection do |connection|
        self.with_store(store_desc, connection) do |store|
          model = SDBFactory.connect_named_model(store,model_uri)
          begin
            result = block.call(model)
          ensure
            model.close
          end
          result
        end
      end
    end

  end

end
