class BriefSummary < ActiveRecord::Base

  belongs_to :study, :foreign_key=> 'nct_id'

end
