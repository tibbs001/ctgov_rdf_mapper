module VivoMapper
  class Address < Resource
    attr_reader :uid, :label, :street, :city, :state, :zip_code, :country, :phone, :person_uid, :address_type, :phone

    def initialize(attributes = {})
      [:uid, :label, :street, :city, :state, :zip_code, :country, :phone, :person_uid, :address_type, :phone].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
