require 'java'
require MAPPER_ROOT + '/lib/vivo_mapper/rdf_prefixes.rb'
Dir.glob(MAPPER_ROOT + '/lib/vivo_mapper/javalib/**/*.jar') {|file| require file}
Dir.glob(MAPPER_ROOT + '/lib/vivo_mapper/**/*.rb') {|file| require file}
