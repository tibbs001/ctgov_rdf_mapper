module VivoMapper
  class Education < Resource
    attr_reader :uid, :label, :major_field_of_study, :degree_uid, :start_year, :start_date, :end_year, :end_date, :person_uid, :institution_uid

    def initialize(attributes = {})
      [:uid, :label, :major_field_of_study, :degree_uid, :start_year, :start_date, :end_year, :end_date, :person_uid, :institution_uid].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

    def date_interval
      if end_date
        DateInterval.new(nil,end_date,"yearMonthDay")
      elsif end_year
        DateInterval.new(nil,DateTime.parse("01/01/#{end_year}"),"year")
      else
        nil
      end
    end
  end

end
