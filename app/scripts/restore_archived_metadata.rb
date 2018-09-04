require File.join(File.dirname(__FILE__),'..','..','config','environment')
import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))

# site meta-data
import_manager.restore_archived_metadata("http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts")
import_manager.restore_archived_metadata("http://vitro.mannlib.cornell.edu/default/vitro-kb-displayMetadata")


