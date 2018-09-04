class Country < ActiveRecord::Base

  belongs_to :study, :foreign_key=> 'nct_id'

  def wiki_lookup
    LookupCountry.where('name = ?', self.name).first
  end

  def qid
    wiki_lookup.try(:qid)
  end
end
