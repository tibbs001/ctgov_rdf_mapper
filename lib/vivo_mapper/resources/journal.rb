module VivoMapper
  class Journal < Resource
    attr_reader :uid, :label, :most_specific_type

    def initialize(attributes = {})
      [:uid, :label, :most_specific_type].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end
 
  end
end
