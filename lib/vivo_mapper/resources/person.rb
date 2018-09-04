module VivoMapper
  class Person < Resource
    attr_reader :uid, :label, :type, :username, :full_name, :first_name, :last_name, :mid_name, :name_prefix, :name_suffix, :title, :netid, :phone, :overview

    def initialize(attributes = {})
      [:uid, :label, :type, :username, :full_name, :first_name, :last_name, :mid_name, :name_prefix, :name_suffix, :title, :netid, :phone, :overview].each do |attr|
        instance_variable_set("@#{attr}", attributes[attr])
      end
      super()
    end

  end
end
