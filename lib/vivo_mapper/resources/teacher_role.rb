module VivoMapper
  class TeacherRole < Resource
    attr_reader :course_uid, :person_uid, :label

    def initialize(attributes = {})
      [:course_uid, :person_uid, :label].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end

  end
end
