require 'lib/vivo_mapper'
require 'rubygems'
require 'fastercsv'
require 'spec/mapper_spec_helper.rb'

new_person   = TestJenaObjects.test_person_model
x=VivoMapper::ImportManager.new('fdr','person')
x.truncate('incoming')
puts "BEFORE: ----should be empty--------------------------"
x.export('incoming')
x.load_model('incoming', new_person)
puts "AFTER:   ----------should have one person--------------------"
x.export('incoming')
x.import('simple')
puts "STAGING:   ------------------------------"
x.export('staging')
puts "DESTINATION   ------------------------------"
x.export('destination')
new_person   = TestJenaObjects.test_person_modified_model
x.truncate('incoming')
x.load_model('incoming', new_person)
puts "Differences before load   ------------------------------"
x.differences_between('incoming','staging')
x.import('difference')
puts "Differences after load   ------------------------------"
x.differences_between('incoming','staging')
exit

people = []
rows = FasterCSV.read('spec/files/Person.csv', :headers => true)
rows.each do |row|
  person_params = {
     :label    => row[1],
     :duid     => row[2],
     :last_name  => row[5],
     :first_name => row[6],
     :mid_name   => row[7],
     :email      => row[8],
     :phone      => row[9],
     :title      => row[10],
     :type       => "FacultyMember",
     :name_prefix => row[12],
     :name_suffix => row[13]
  }
  people << VivoMapper::Person.new(person_params)
end

x=VivoMapper::ImportManager.new('fdr','person','development')
x.truncate('incoming')
puts "BEFORE: ------------------------------"
x.export('incoming')
x.load_resources('incoming', people)
puts "AFTER:   ------------------------------"
x.export('incoming')
exit

#load_model(local_h2_database,"people_incoming",people)
#write_model(local_h2_database,"people_incoming")

local_vivo_database = VivoMapper::SDB.new('jdbc:mysql://localhost/vivo_development','vivodev','local_vivo_work','','MySQL','layout2/hash')

#local_vivo_database.with_named_model("http://vitro.mannlib.cornell.edu/default/vitro-kb-2") do |destination_model|
  #local_h2_database.with_named_model("people_incoming") do |incoming_model|
    #sl = VivoMapper::SimpleLoader.new(destination_model)
    #sl.add_model(incoming_model)
  #end
#end

#load_model(local_h2_database,"people_staging",people)
#load_model(local_h2_database,"people_destination",people)
#
#

#h2 = SDB.new
#vivo = SDB.new...

# get data here
#people

#ImportManaget.new(h2,vivo,namespace,name,people)

#class ImportManaget
#  name_incoming|stagge (h2)
#  dest = kb-2 from vivo
#  ont model = core + duke from vivo
#  people - run through mapper - drop into icoming
#  instantiate diffloader
#  run import_model 
#end

