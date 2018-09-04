module VivoMapper
  class Professorship < Resource
    attr_reader :uid, :label, :title, :display_order, :start_date, :end_date, :position_type, :person_uid, :organization_uid

    def initialize(attributes = {})
      [:uid, :label, :title, :display_order, :start_date, :end_date, :position_type, :person_uid, :organization_uid].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end
 
    def date_interval
      DateInterval.new(start_date,end_date,"yearMonthDay") if start_date
    end
    
  end
end
