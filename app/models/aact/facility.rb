module Aact
  class Facility < Aact::Base

    belongs_to :study, :foreign_key=> 'nct_id'

    def label
      name
    end

    def uid
      'xxxx'
    end

  end
end
