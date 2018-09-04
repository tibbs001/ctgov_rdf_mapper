module PermissionSetMap
  include RdfPrefixes

  extend self

  def uri(namespace,u)
    "http://permissionSet-#{u.uid}"
  end

  def types(u)
    [auth("PermissionSet")]
  end

  def inferred_types(u)
    [] 
  end

  def properties(u)
    {
      vitro("label") => u.label,
    }
  end

end
