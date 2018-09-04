require 'rubygems'
require 'active_record'
require 'lib/vivo_mapper'
require 'lib/vivo_mapper/managers/import_manager'
require 'model/course'
require 'model/person'
require 'valium'

config =  VivoMapper::Config.load_from_file('config/sdb.yml')
im = VivoMapper::ImportManager.new(config)
im.truncate('staging')
#im.simple_import('Person',Person.for_vivo)
#im.simple_import('Course',Course.for_vivo)
#im.export('Person','staging')
#im.export('Course','staging')

orgs = []
rows = CSV.read('CurrentOrganization.csv', :headers => true)
rows.each do |row|
  org_params = {
     :uid => row[1],
     :type     => row[2],
     :label    => row[3],
     :parent_organization_uid => "#{row[4]}".gsub('org','')
  }
  orgs << VivoMapper::Organization.new(org_params)
end

im.simple_import('Organization',orgs)
im.export('Organization','staging')
