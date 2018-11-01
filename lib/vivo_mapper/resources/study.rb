require 'date'
module VivoMapper
  class Study < Resource
    attr_reader :nct_id, :phase, :brief_title, :official_title, :acronym, :description, :enrollment, :all_interventions, :all_conditions

    def initialize(attributes = {})
      [:nct_id, :phase, :brief_title, :official_title, :acronym, :description, :enrollment, :all_interventions, :all_conditions].each do |attr|
        instance_variable_set("@#{attr}", attributes.send(attr.to_sym))
      end
      super()
    end

    def uid
      nct_id
    end

    def country_uid
      'ssss'
    end

    def date_interval
      DateInterval.new(DateTime.parse(start_date.to_date.strftime('%Y%m%d')),DateTime.parse(end_date.to_date.strftime('%Y%m%d')),"yearMonthDay")  if start_date and end_date
    end
  end
end
