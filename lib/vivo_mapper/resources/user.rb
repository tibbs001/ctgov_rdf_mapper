module VivoMapper
  class User < Resource
    attr_reader :uid, :external_auth_id, :last_name, :first_name, :email_address, :password, :password_expires, :permission_set, :status, :proxy_editor

    def initialize(attributes = {})
      [:uid, :external_auth_id, :last_name, :first_name, :email_address, :password, :password_expires, :permission_set, :status, :proxy_editor
].each do |attr|
        instance_variable_set("@#{attr}", attributes[attr])
      end
      super()
    end

  end
end
