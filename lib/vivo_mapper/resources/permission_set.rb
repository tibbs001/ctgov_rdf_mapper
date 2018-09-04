module VivoMapper
  class PermissionSet < Resource
    attr_reader :uid, :label

    def initialize(attributes = {})
      [:uid, :label].each do |attr|
        instance_variable_set("@#{attr}", attributes[attr])
      end
      super()
    end

  end
end
