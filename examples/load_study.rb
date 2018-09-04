require 'valium'

config =  VivoMapper::Config.load_from_file('config/sdb.yml')
im = VivoMapper::ImportManager.new(config)
im.truncate('staging')

studies = []
rows = Study.all[0..2]
rows.each do |row|
  row.attributes
  studies << VivoMapper::Study.new(row)
end
im.simple_import('Study',studies)

im.export('Study','staging')
