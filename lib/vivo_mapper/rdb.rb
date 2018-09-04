java_import 'com.hp.hpl.jena.db.DBConnection'
java_import 'com.hp.hpl.jena.db.ModelRDB'

module VivoMapper

  class RDB

    def initialize(url,username,password,driver_class_name,db_type,layout_type)
      @url, @username, @password, @driver_class_name, @db_type, @layout_type = url, username, password, driver_class_name, db_type, layout_type
    end

    def self.from_sdb(sdb)
      new(sdb.url, sdb.username, sdb.password, sdb.driver_class_name, sdb.db_type, sdb.layout_type)
    end

    def with_connection(&block)
      java_import @driver_class_name
      connection = DBConnection.new(@url,@username,@password,@db_type)
      begin
        block.call(connection)
      ensure
        connection.close
      end
    end

    def with_named_model(model_name,&block)
      with_connection do |connection|
        if connection.contains_model(model_name)
          model = ModelRDB.open(connection,model_name)
        else
          model = ModelRDB.create_model(connection,model_name)
        end
        begin
          block.call(model)
        ensure
          model.close
        end
      end
    end

  end
end
