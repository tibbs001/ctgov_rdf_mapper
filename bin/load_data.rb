require File.join(File.dirname(__FILE__),'..','config','environment')
include Java
import java.lang.System 
action = System.get_property('action')

case action
when 'load_all'
  DataLoader.new.load_people
  DataLoader.new.load_courses
  DataLoader.new.load_grants
when 'load_people'
  DataLoader.new.load_people
when 'load_courses'
  DataLoader.new.load_courses
when 'load_grants'
  DataLoader.new.load_grants
when 'load_publications'
  DataLoader.new.load_publications
when 'load_all_grants'
  DataLoader.new.load_all_grants
when 'load_users'
  DataLoader.new.import_other(:simple_import,'User',User.from_file(File.join(MAPPER_ROOT,'incoming_files','User.csv')), 'http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts',:rdb)
when 'export_kb2'
  import_manager = VivoMapper::ImportManager.new(SDB_CONFIG,StdoutLogger.new(:only => [:add_to_destination,:remove_from_destination]))
  import_manager.export('http://vitro.mannlib.cornell.edu/default/vitro-kb-2','destination')
when 'refresh_grant_view'
  Grant.refresh_view
else
  puts "invalid action: #{action}"
end

