module Aact
  class Sponsor < Aact::Base

    belongs_to :study, :foreign_key=> 'nct_id'

  end
end
