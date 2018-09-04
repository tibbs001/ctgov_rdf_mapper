require File.join(File.dirname(__FILE__),'..','..','config','environment')
import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))

# anything vivo owns (not in staging)
import_manager.archive_destination_difference

# site meta-data
import_manager.archive_metadata("http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts")
import_manager.archive_metadata("http://vitro.mannlib.cornell.edu/default/vitro-kb-displayMetadata")


#import_manager.export("http://vitro.mannlib.cornell.edu/default/vitro-kb-2",'archive')
#import_manager.export("http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts",'archive')
#import_manager.export("http://vitro.mannlib.cornell.edu/default/vitro-kb-displayMetadata",'archive')
