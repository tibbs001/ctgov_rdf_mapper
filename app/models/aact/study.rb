module Aact

  class Study < Aact::Base

    attr_accessor :description

    self.primary_key = 'nct_id'
    has_one  :brief_summary, :foreign_key => 'nct_id'
    has_many :countries,  :foreign_key => 'nct_id'
    has_many :facilities, :foreign_key => 'nct_id'
    has_many :sponsors,   :foreign_key => 'nct_id'

    def attributes
      self.description = self.brief_summary.description if self.brief_summary
    end

    def uid
      nct_id
    end

    def self.for_vivo
      studies=[]
      rows = self.all
      rows.each do |row|
        row.attributes
        studies << VivoMapper::Study.new(row)
      end
      studies
    end

  end
end
