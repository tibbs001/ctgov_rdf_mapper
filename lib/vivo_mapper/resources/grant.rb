require 'date'
module VivoMapper
  class Grant < Resource
    attr_reader :uid, :label, :parent_uid, :person_uid, :faculty_name, :institution_uid, :sponsor, :organization_uid, :start_date, :end_date, :investigator_role

    def initialize(attributes = {})
      [:uid, :label, :parent_uid, :person_uid, :faculty_name, :institution_uid, :sponsor, :organization_uid, :start_date, :end_date, :investigator_role].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end
  
    def date_interval
      DateInterval.new(DateTime.parse(start_date.to_date.strftime('%Y%m%d')),DateTime.parse(end_date.to_date.strftime('%Y%m%d')),"yearMonthDay")  if start_date and end_date
    end
  end
end
