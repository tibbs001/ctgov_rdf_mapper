module CourseMap
  include RdfPrefixes
  extend self

  def uri(namespace,course)
    "#{namespace}course#{course.uid}"
  end

  def types(course)
    [core("Course")]
  end

  def inferred_types(c)
    [owl("Thing"), event("Event")]
  end

  def child_maps(c)
    [teacher(c)]
  end

  def teacher(c)
    faculty_name = Person.find_by_duid(c.person_uid).try(:professional_name)
    VivoMapper::TeacherRole.new(:course_uid => c.uid,:person_uid => c.person_uid, :label => 'Instructor')
  end

  def properties(c)
    { 
      rdfs("label")       => c.label,
      core("realizedRole") => teacher(c),
      core("dateTimeInterval")  => c.date_interval
    }
  end

end
