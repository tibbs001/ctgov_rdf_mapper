module VivoMapper
  class Degree < Resource
    attr_reader :uid, :label, :degree_abbreviation

    def initialize(attributes = {})
      [:uid, :label, :degree_abbreviation].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
