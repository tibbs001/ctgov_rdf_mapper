module VivoMapper
  class Organization < Resource
    attr_reader :uid, :label, :type, :parent_organization_uid

    def initialize(attributes = {})
      [:uid, :label, :type, :parent_organization_uid].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
