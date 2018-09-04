module TeacherRoleMap
  include RdfPrefixes

  extend self

  def uri(namespace,teacher_role)
    "#{namespace}teacherRole#{uid(teacher_role)}"
  end

  def types(teacher_role)
    [core("TeacherRole")]
  end

  def inferred_types(teacher_role)
    [foaf("Role"), owl("Thing")]
  end

  def properties(teacher_role)
    {
      rdfs("label")             => teacher_role.label,
      core("roleRealizedIn")    => VivoMapper::Course.new(:uid => teacher_role.course_uid).stub,
      core("teacherRoleOf")     => VivoMapper::Person.new(:uid => teacher_role.person_uid).stub,
    }
  end

  def uid(teacher_role)
    "#{teacher_role.course_uid}-#{teacher_role.person_uid}"
  end
end
