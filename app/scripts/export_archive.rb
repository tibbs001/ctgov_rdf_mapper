require File.join(File.dirname(__FILE__),'..','..','config','environment')
import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
import_manager.export('http://vitro.mannlib.cornell.edu/default/vitro-kb-2','archive')
