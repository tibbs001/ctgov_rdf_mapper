class ResearchInterest < ActiveRecord::Base

  def self.for_duids(duids)
    array = ResearchInterest.where('duid is not null').value_of :id, :duid, :concept_id
    all = []
    array = array.select{ |a| duids.include? a[1]}
    array.map {|a| 
      concept = 
      all << VivoMapper::ResearchInterest.new(
       :uid           => a[0],
       :person_uid    => a[1],
       :concept       => Concept.find(a[2]).concept)
    }  
    all
  end

  def self.destined_for_vivo(duids)
    Hide.remove_hidden_from(self.for_duids(duids),'ResearchInterest')
  end

  def self.for_vivo
    self.destined_for_vivo(Person.duids_for_vivo)
  end

end
