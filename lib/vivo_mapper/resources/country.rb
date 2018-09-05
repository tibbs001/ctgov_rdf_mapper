module VivoMapper
  class Country < Resource
    attr_reader :uid, :nct_id, :label

    def initialize(attributes = {})
      [ :uid, :nct_id, :label ].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
