require 'date'
module VivoMapper
  class InvestigatorRole < Resource
    attr_reader :uid, :person_uid, :label, :role_type, :start_date, :end_date
 
    def initialize(attributes = {})
      [:uid, :person_uid, :label, :role_type, :start_date, :end_date].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

    def date_interval
      DateInterval.new(DateTime.parse(start_date.to_date.strftime('%Y%m%d')),DateTime.parse(end_date.to_date.strftime('%Y%m%d')),"yearMonthDay")  if start_date and end_date
    end
  end
end
