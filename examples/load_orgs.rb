require 'lib/vivo_mapper'
require 'rubygems'
require 'fastercsv'
require 'spec/mapper_spec_helper.rb'

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


def load_staging(models=[])
  staging = VivoMapper::SDB.new('jdbc:h2:examples','','','','H2','layout2/hash')
  staging.with_named_model("organization_staging") do |model|
    ontology_model = TestJenaObjects.vivo_ontology_model_with_duke_extensions
    mapper = VivoMapper::Mapper.new("https://scholars.duke.edu/individual/",model,ontology_model)
    models.each do |org|
      mapper.map_resource(org)
    end
  end
end

def add_to_vivo
  vivo = VivoMapper::SDB.new('jdbc:mysql://localhost/vivo_development','vivodev','local_vivo_work','','MySQL','layout2/hash')
  vivo.with_named_model("http://vitro.mannlib.cornell.edu/default/vitro-kb-2") do |model|
   staging = VivoMapper::SDB.new('jdbc:h2:examples','','','','H2','layout2/hash')
   staging.with_named_model("organization_staging") do |incoming_model|
     model.add(incoming_model)
   end

  end
end


def write_staging
  staging = VivoMapper::SDB.new('jdbc:h2:examples','','','','H2','layout2/hash')
  staging.with_named_model("organization_staging") do |model|
    model.write(java.lang.System.out)
  end
end

#java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
#java_import 'com.hp.hpl.jena.reasoner.ReasonerRegistry'

#sdb = VivoMapper::SDB.new('jdbc:h2:examples','','','','H2','layout2/hash')
#sdb.with_named_model("organization_staging") do |model|
  #ontology_model = TestJenaObjects.vivo_ontology_model_with_duke_extensions
  #reasoner = ReasonerRegistry.get_owl_reasoner
  #reasoner.bind_schema(ontology_model)
#  model.write(java.lang.System.out)
  #inf_model = ModelFactory.createInfModel(reasoner,model)
  #inf_model.write(java.lang.System.out)
#end

load_staging(orgs)
write_staging
#add_to_vivo
#puts orgs.map(&:inspect)
