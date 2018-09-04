module VivoMapper
  class Authorship < Resource

    attr_reader :uid, :pub_uid, :author_uid, :label, :author_rank
 
    def initialize(attributes = {})
      [:pub_uid, :author_uid, :label, :author_rank].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      @uid = "#{pub_uid}-#{author_uid}"
      super()
    end

  end
end
