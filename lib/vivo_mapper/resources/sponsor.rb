module VivoMapper
  class Sponsor < Resource
    attr_reader :nct_id, :name

    def initialize(attributes = {})
      [:nct_id, :name].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

    def uid
      nct_id
    end

    def label
      name
    end

  end
end
