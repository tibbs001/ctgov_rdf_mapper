class Hide < ActiveRecord::Base

  #attr_accessible :duid, :data_type, :unique_id, :label
  attr_accessor :duid, :data_type, :unique_id, :label

  def self.duids_for_section(type)
    Hide.where("data_type=? and unique_id is null",type).collect{|x| x.duid}
  end

  def self.for_individual(type)
    Hide.where("data_type='#{type}' and unique_id is not null")
  end

  def self.individuals_for_duid_and_type(duid,type)
    where(["duid=? and data_type=?",duid,type])
  end

  def self.remove_hidden_from(collection, type)
    hide_all = self.duids_for_section(type)
    hide_individuals = self.for_individual(type)

    collection.delete_if{|entry| hide_all.include? entry.person_uid}
    collection.delete_if{|entry| hide_individuals.any?{|h| h.duid == entry.person_uid} && hide_individuals.any?{|h| h.unique_id.to_s == entry.uid.to_s}}
    collection
  end

  def self.hide_individuals(duid,type,individuals={})
    logger.info "in hide_individuals"
    unhide_individuals(duid,type,individuals.keys)
    individuals.each do |unique_id, label|
      logger.info "hiding #{duid}  #{label}"
      create!(:duid => duid, :data_type => type, :unique_id => unique_id, :label => label)
    end
  end

  def self.unhide_individuals(duid,type,unique_ids=[])
    logger.info "in unhide_individuals"
    unique_ids.each do |unique_id|
      if individual = find_by_duid_and_data_type_and_unique_id(duid,type,unique_id)
        individual.destroy
      end
    end
  end

  def self.hide_section(duid, type)
    unhide_section(duid,type)
    create!(:duid => duid, :data_type => type)
  end

  def self.unhide_section(duid,type)
    if section = find_by_duid_and_data_type_and_unique_id(duid,type,nil)
      section.destroy
    end
  end
end
