module Aact
  class BriefSummary < Aact::Base

    belongs_to :study, :foreign_key=> 'nct_id'

  end
end
