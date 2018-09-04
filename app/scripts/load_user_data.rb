require File.join(File.dirname(__FILE__),'..','..','config','environment')
#import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
#import_manager.difference_import('User', User.from_file(File.join(MAPPER_ROOT,'incoming_files','User.csv')), 'http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts',:rdb)

DataLoader.new.import_other(:difference_import,'User',User.from_file(File.join(MAPPER_ROOT,'incoming_files','User.csv')), 'http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts',:rdb)


