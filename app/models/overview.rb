class Overview < ActiveRecord::Base

  def self.for_duids(duids)
    array = Overview.where('overview is not null').value_of :id, :duid, :overview
    all = []
    array = array.select{ |a| duids.include? a[1]}
    array.map {|a| 
      all << VivoMapper::Overview.new(
       :uid          => a[0],
       :person_uid   => a[1],
       :overview     => a[2])
    } 
    all
  end

  def self.destined_for_vivo(duids)
    Hide.remove_hidden_from(self.for_duids(duids),'Overview')
  end

  def self.for_vivo
    self.destined_for_vivo(Person.duids_for_vivo)
  end

end
