module VivoMapper
  class Publication < Resource
    attr_reader :uid, :pmid, :title, :author_uid, :author_list, :author_rank, :author_label, :journal_uid, :journal_name, :pub_date, :pub_year, :webpage, :volume, :issue, :edition, :number, :section, :oclc_number, :start_page, :end_page, :abstract, :pub_type 

    def initialize(attributes = {})
      [:uid, :pmid, :title, :author_uid, :author_list, :author_rank, :author_label, :journal_uid, :journal_name, :pub_date, :pub_year, :webpage, :volume, :issue, :edition, :number, :section, :oclc_number, :start_page, :end_page, :abstract, :pub_type].each do |attr|
        instance_variable_set("@#{attr}",attributes[attr])
      end
      super()
    end
 
    def authorship
      VivoMapper::Authorship.new(:pub_uid => uid, :author_uid => author_uid, :label => author_label, :author_rank => author_rank)
    end

    def journal
      VivoMapper::Journal.new(:uid => journal_uid, :label => journal_name, :most_specific_type => 'Journal')
    end

    def pub_date_object
      if pub_date
        VivoMapper::DateValue.new(DateTime.new(pub_date),"yearMonthDay")
      elsif pub_year
        VivoMapper::DateValue.new(DateTime.parse("01/01/#{pub_year}"),"year")
      else
        nil
      end
    end
  end
end
