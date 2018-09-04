module UserMap
  include RdfPrefixes

  extend self

  def uri(namespace,u)
    "#{namespace}user#{u.uid}"
  end

  def types(u)
    [auth("UserAccount")]
  end

  def inferred_types(u)
    [] 
  end

  def proxy_editor_for(proxy_uid)
    return nil if proxy_uid.blank?
    return VivoMapper::Person.new(:uid => proxy_uid.gsub(/per/, '') ).stub       if proxy_uid.include? 'per'
    return VivoMapper::Organization.new(:uid => proxy_uid.gsub(/org/, '') ).stub if proxy_uid.include? 'org'
  end

  def permission_code(role)
    case role.downcase
      when 'selfeditor'
        return 'http://permissionSet-1'
        #return VivoMapper::PermissionSet.new(:uid => '1').stub 
      when 'editor'
        return 'http://permissionSet-4'
        #return VivoMapper::PermissionSet.new(:uid => '4').stub 
      when 'curator'
        return 'http://permissionSet-5'
        #return VivoMapper::PermissionSet.new(:uid => '5').stub 
      when 'admin'
        return 'http://permissionSet-50'
        #return VivoMapper::PermissionSet.new(:uid => '50').stub 
      else
        return 'http://permissionSet-1'
        #return VivoMapper::PermissionSet.new(:uid => '1').stub 
    end
  end

  def properties(u)
    {
      auth("externalAuthId")       => u.external_auth_id,
      auth("lastName")             => u.last_name,
      auth("firstName")            => u.first_name,
      auth("emailAddress")         => u.email_address,
      auth("md5password")          => u.password,
      auth("passwordLinkExpires")  => u.password_expires,
      auth("status")               => u.status,
      auth("proxyEditorFor")       => proxy_editor_for(u.proxy_editor),
      auth("hasPermissionSet")     => permission_code(u.permission_set ? u.permission_set : 'selfeditor'),
      auth("passwordLinkExpires")  => 0,
      auth("loginCount")           => 0,
      auth("passwordChangeRequired")  => true,
      auth("externalAuthOnly")        => true,
    }
  end

end
