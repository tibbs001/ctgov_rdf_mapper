#require 'valium'
studies = Aact::Study.for_vivo[0..3]
import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
import_manager.truncate('staging')
import_manager.truncate('destination')
import_manager.simple_import('Study', studies)
import_manager.export('Study','staging')

import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
import_manager.export('http://vitro.mannlib.cornell.edu/default/vitro-kb-2','destination')






#config =  VivoMapper::Config.load_from_file('config/sdb.yml')
#im = VivoMapper::ImportManager.new(config)
#im.truncate('staging')

#studies = Aact::Study.for_vivo
#im.simple_import('Study',studies)

#VivoMapper::ImportManager.simple_import('Study', studies)


#facilities = []
#rows = Aact::Facility.all
#rows.each do |row|
#  row.attributes
#  facilities << VivoMapper::Facility.new(row)
#end
#im.simple_import('Facility',facilities)
#im.export('Study','staging')
