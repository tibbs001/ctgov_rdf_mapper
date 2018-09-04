module VivoMapper
  class SimpleLoader < Loader

    def add_model(incoming_model)
      @staging_model.add(incoming_model)
      log_data(:add_to_staging, incoming_model)
      @destination_model.add(incoming_model)
      log_data(:add_to_destination, incoming_model)
    end
 
    def remove_model(incoming_model)
      @staging_model.remove(incoming_model)
      log_data(:remove_from_staging, incoming_model)
      @destination_model.remove(incoming_model)
      log_data(:remove_from_destination, incoming_model)
    end

  end
end
