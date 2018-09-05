module Aact
  class Country < Aact::Base

    belongs_to :study, :foreign_key=> 'nct_id'

    def qid
      WikiLookup.lookup('Country', self)
        where('name = ?', self.name).first.try(:quid)
    end
  end
end
