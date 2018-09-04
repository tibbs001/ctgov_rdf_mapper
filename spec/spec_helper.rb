MAPPER_ROOT = File.join(File.dirname(File.expand_path(__FILE__)),"..")

require 'vivo_mapper'

SPEC_ROOT = File.dirname(__FILE__)

class TestHelper
  def self.get_import_manager
     config = VivoMapper::Config.load_from_file('spec/files/test_configs.yml','test')
     config.read_ontology_file('config/ontologies/vivo-core-public-1.4.owl')
     config.read_ontology_file('config/ontologies/vitro-0.7.owl')
     config.read_ontology_file('config/ontologies/duke_extension.owl')
     return VivoMapper::ImportManager.new(config)
  end
end
 
