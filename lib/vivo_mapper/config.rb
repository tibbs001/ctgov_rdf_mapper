require 'rubygems'
require 'yaml'
java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.util.FileManager'

module VivoMapper
  class Config

    attr_reader :namespace, :ontology_model, :destination_model_name, :inference_model_name, :incoming_sdb, :staging_sdb, :archive_sdb, :destination_sdb

    def self.load_from_file(file_name, mode='development')
      configs = YAML.load(File.read(file_name))
      config = configs[mode]
      namespace              = config['namespace']
      destination_model_name = config['destination_model_name']
      inference_model_name   = config['inference_model_name']
      ['incoming','staging','archive','destination'].each do |phase|
        db_name    = config[phase]['sdb']
        username   = config[phase]['username']
        password   = config[phase]['password']
        driver     = config[phase]['driver']
        db_type    = config[phase]['db_type']
        db_layout  = config[phase]['db_layout']
        @incoming_sdb = VivoMapper::SDB.new(db_name, username, password, driver, db_type, db_layout) if phase == 'incoming'
        @staging_sdb = VivoMapper::SDB.new(db_name, username, password, driver, db_type, db_layout) if phase == 'staging'
        @archive_sdb = VivoMapper::SDB.new(db_name, username, password, driver, db_type, db_layout) if phase == 'archive'
        @destination_sdb = VivoMapper::SDB.new(db_name, username, password, driver, db_type, db_layout) if phase == 'destination'
        @ontology_model  = ModelFactory.create_ontology_model
      end

      config = {
       :namespace   => namespace,
       :incoming_sdb => @incoming_sdb,
       :staging_sdb => @staging_sdb,
       :archive_sdb => @archive_sdb,
       :destination_sdb => @destination_sdb,
       :destination_model_name => destination_model_name,
       :inference_model_name => inference_model_name
      }
      self.new(config)
    end

    def initialize(options={})
      @incoming_sdb    = options[:incoming_sdb]
      @staging_sdb     = options[:staging_sdb]
      @archive_sdb     = options[:archive_sdb]
      @destination_sdb = options[:destination_sdb]
      @namespace       = options[:namespace]
      @destination_model_name  = options[:destination_model_name]
      @inference_model_name    = options[:inference_model_name]
      @ontology_model  = options[:ontology_model] || ModelFactory.create_ontology_model
    end

    def read_ontology_file(filename)
      FileManager.get.readModel(@ontology_model,filename)
    end

  end
end

