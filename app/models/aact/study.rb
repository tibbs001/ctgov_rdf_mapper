module Aact

  class Study < Aact::Base

    attr_accessor :description

    self.primary_key = 'nct_id'
    has_one  :brief_summary, :foreign_key => 'nct_id'
    has_many :countries,  :foreign_key => 'nct_id'
    has_many :facilities, :foreign_key => 'nct_id'
    has_many :sponsors,   :foreign_key => 'nct_id'

    def attributes
      self.description=self.brief_summary.description
    end

    def uid
      nct_id
    end

  end
end
