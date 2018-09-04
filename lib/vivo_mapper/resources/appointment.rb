require 'date'

module VivoMapper
  class Appointment < Resource
    attr_reader :uid, :label, :title, :display_order, :start_year, :start_date, :end_year, :end_date, :position_type, :person_uid, :organization_uid

    def initialize(attributes = {})
      [:uid, :label, :title, :display_order, :start_year, :start_date, :end_year, :end_date, :position_type, :person_uid, :organization_uid].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

    def date_interval
      if start_date
        DateInterval.new(start_date,end_date,"yearMonthDay")
      elsif start_year
        end_at = end_date ? DateTime.parse("01/01/#{end_year}") : nil
        DateInterval.new(DateTime.parse("01/01/#{start_year}"),end_at,"year")
      else
        nil
      end
    end
  end
end
