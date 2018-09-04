module VivoMapper
  class DifferenceLoader < Loader
    attr_reader  :add_change_model, :remove_model

    def differences(incoming_model, diff_model=@staging_model)
      incoming_model.difference(diff_model)
    end

    def import_model(incoming_model, diff_model=@staging_model)
      @add_change_model = incoming_model.difference(diff_model)
      @remove_model     = diff_model.difference(incoming_model)

      @staging_model.add(add_change_model)
      log_data(:add_to_staging, add_change_model)
      @destination_model.add(add_change_model)
      log_data(:add_to_destination, add_change_model)

      @staging_model.remove(remove_model)
      log_data(:remove_from_staging,remove_model)
      @destination_model.remove(remove_model)
      log_data(:remove_from_destination,remove_model)
    end
  end
end
