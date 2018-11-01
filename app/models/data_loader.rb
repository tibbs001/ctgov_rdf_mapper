#require File.join(File.dirname(__FILE__),'..','..','config','environment')

class DataLoader

  attr_reader  :config, :import_manager

  def self.load_studies
    studies = Aact::Study.for_vivo[0..3]
    import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
    import_manager.truncate('staging')
    import_manager.truncate('destination')
    import_manager.simple_import('Study', studies)
    import_manager.export('Study','staging')

    import_manager.export('http://vitro.mannlib.cornell.edu/default/vitro-kb-2','destination')
  end

  def initialize
     @config = SDB_CONFIG
     @import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
  end

  def load_people(type_of_import=:difference_import)
    meth = type_of_import.to_sym
    import(meth, 'Organization',    Organization.for_vivo)
    import(meth, 'Address',         Address.for_vivo)
    import(meth, 'Appointment',     Appointment.from_file(File.join(MAPPER_ROOT,'incoming_files','Appointment.csv')))
    import(meth, 'Degree',          Degree.from_file(File.join(MAPPER_ROOT,'incoming_files','Degree.csv')))
    import(meth, 'Education',       Education.from_file(File.join(MAPPER_ROOT,'incoming_files','Education.csv')))
    import(meth, 'Institution',     Institution.from_file(File.join(MAPPER_ROOT,'incoming_files','Institution.csv')))
    import(meth, 'Person',          Person.from_file(File.join(MAPPER_ROOT,'incoming_files','Person.csv')))
    import(meth, 'Professorship',   Professorship.for_vivo)
    import(meth, 'ResearchInterest',ResearchInterest.for_vivo)
  end

  def load_all_grants
    alphabet = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    total_grants = 0
    alphabet.each do |letter|
      puts ">>> #{Time.now.strftime('%I:%M%p')} retrieving #{letter} grants..."
      grants=Grant.for_vivo_sponsor_initial(letter)
      total_grants += grants.size
      puts ">>> #{Time.now.strftime('%I:%M%p')} #{letter}: importing #{grants.size} grants.  Cumulative total: #{total_grants}"
      import(:simple_import,'Grant',grants) if grants.size > 0
    end
  end

  def load_publications
    import(:simple_import, 'Publication',  Publication.from_file(File.join(MAPPER_ROOT,'incoming_files','Publication.csv')))
  end

  def load_grants(type_of_import=:difference_import)
    meth =  type_of_import.to_sym
    import(meth,'Grant',Grant.for_vivo)
  end

  def load_courses(type_of_import=:difference_import, strm='1390')
    meth = type_of_import.to_sym
    import(meth, 'Course', Course.for_strm_and_duids(strm, Person.duids_for_vivo))
  end

  def load_individual(duid, type)
    type_model = type.constantize
    resources = type_model.destined_for_vivo([duid])
    @import_manager.individual_difference_import(duid, type, resources, @config.destination_model_name)
    @import_manager.individual_difference_import(duid, type, resources, @config.inference_model_name, 'Inferred')
  end

  def import(meth, model_name, resources)
    @import_manager.send(meth, model_name, resources, @config.destination_model_name)
    @import_manager.send(meth, model_name, resources, @config.inference_model_name, 'Inferred')
  end

  def import_other(meth, model_name, resources, destination_model_name, store_type=:sdb)
    @import_manager.send(meth, model_name, resources, destination_model_name, 'Regular', store_type)
  end
end
