require File.join(File.dirname(__FILE__),'..','..','config','environment')
im = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
im.individual_difference_import('0079828','Address', Address.destined_for_vivo('0079828')))
