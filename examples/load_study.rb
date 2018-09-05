#require 'valium'

config =  VivoMapper::Config.load_from_file('config/sdb.yml')
im = VivoMapper::ImportManager.new(config)
im.truncate('staging')

studies = []
rows = Aact::Study.all
rows.each do |row|
  row.attributes
  studies << VivoMapper::Study.new(row)
end
im.simple_import('Study',studies)

facilities = []
rows = Aact::Facility.all
rows.each do |row|
  row.attributes
  facilities << VivoMapper::Facility.new(row)
end
im.simple_import('Facility',facilities)


im.export('Study','staging')
