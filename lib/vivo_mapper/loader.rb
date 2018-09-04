module VivoMapper
  class Loader
    attr_reader :staging_model, :destination_model, :logger

    def initialize(staging_model, destination_model, logger=nil)
      @staging_model, @destination_model, @logger = staging_model, destination_model, logger
    end

    def log_data(command, model)
      output_stream=java.io.ByteArrayOutputStream.new
      model.write(output_stream,"RDF/XML")
      @logger.log(command, output_stream.to_string) if @logger
    end

  end
end
