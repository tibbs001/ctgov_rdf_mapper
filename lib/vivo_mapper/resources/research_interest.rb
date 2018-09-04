module VivoMapper
  class ResearchInterest < Resource
    attr_reader :uid, :person_uid, :concept

    def initialize(attributes = {})
      [:uid, :person_uid, :concept].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
