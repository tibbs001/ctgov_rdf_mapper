module VivoMapper
  class Institution < Resource
    attr_reader :uid, :label, :institution_type

    def initialize(attributes = {})
      [:uid, :label, :institution_type].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
