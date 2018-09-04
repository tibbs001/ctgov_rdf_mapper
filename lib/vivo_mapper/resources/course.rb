module VivoMapper
  class Course < Resource
    attr_reader :uid, :label, :person_uid, :start_date, :start_year, :term, :teacher_role

    def initialize(attributes = {})
      [:uid, :label, :person_uid, :start_date, :start_year, :term, :teacher_role].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

    def date_interval
      if start_date
        DateInterval.new(start_date,nil,"yearMonthDay")
      elsif start_year
        DateInterval.new(DateTime.parse("01/01/#{start_year}"),nil,"year")
      else
        nil
      end
    end

  end
end
