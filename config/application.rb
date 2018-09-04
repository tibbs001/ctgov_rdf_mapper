require File.expand_path('../boot', __FILE__)
require "rails"
require "active_model/railtie"
require "active_record/railtie"
require 'zip'
require 'fastercsv'
require 'rubygems'
#require 'valium'

MAPPER_ROOT = File.join(File.dirname(File.expand_path(__FILE__)),"..")
require MAPPER_ROOT + '/lib/vivo_mapper.rb'

Bundler.require(*Rails.groups)
Dir.glob("#{MAPPER_ROOT}/app/maps/**/*.rb") {|file| require file}

class Application < Rails::Application
  puts "in Application < Rails::Application definition...."
  config.time_zone = 'Eastern Time (US & Canada)'
  config.quiet_assets = true
  config.eager_load = false
  config.generators do |generate|
    generate.helper false
    generate.request_specs false
    generate.routing_specs false
    generate.test_framework :rspec
  end
  config.active_record.schema_format = :sql
  #config.active_record.raise_in_transactional_callbacks = true
end


# require resource maps
Dir.glob("#{MAPPER_ROOT}/app/maps/**/*.rb") {|file| require file}

# wire mappings
VivoMapper::Study.map_with(StudyMap)
#VivoMapper::Address.map_with(AddressMap)
#VivoMapper::Appointment.map_with(AppointmentMap)
#VivoMapper::Authorship.map_with(AuthorshipMap)
#VivoMapper::Course.map_with(CourseMap)
#VivoMapper::DateInterval.map_with(DateIntervalMap)
#VivoMapper::DateValue.map_with(DateValueMap)
#VivoMapper::Degree.map_with(DegreeMap)
#VivoMapper::Education.map_with(EducationMap)
#VivoMapper::Grant.map_with(GrantMap)
#VivoMapper::Institution.map_with(InstitutionMap)
#VivoMapper::InvestigatorRole.map_with(InvestigatorRoleMap)
#VivoMapper::Journal.map_with(JournalMap)
VivoMapper::Organization.map_with(OrganizationMap)
#VivoMapper::Person.map_with(PersonMap)
#VivoMapper::PermissionSet.map_with(PermissionSetMap)
#VivoMapper::Professorship.map_with(ProfessorshipMap)
#VivoMapper::Publication.map_with(PublicationMap)
#VivoMapper::ResearchInterest.map_with(ResearchInterestMap)
#VivoMapper::TeacherRole.map_with(TeacherRoleMap)
#VivoMapper::User.map_with(UserMap)

# require app models
Dir.glob("#{MAPPER_ROOT}/app/models/**/*.rb") {|file| require file}

# require app loggers
Dir.glob("#{MAPPER_ROOT}/app/loggers/**/*.rb") {|file| require file}

# load database configs
#DATABASE_CONFIGS = {}
#puts "======================================="
#Dir.glob("#{MAPPER_ROOT}/config/databases/*.yml") do |database_yaml|
#  puts "= database yaml: #{database_yaml}  ============================"
#  config_key = File.basename(database_yaml,'.*').to_sym
#  puts "= config_key: #{config_key}  ============================"
#  config = YAML.load(File.read(database_yaml))
#  puts "        00000000000000000000000000"
#  puts "          #{config[ENV['MAPPER_ENV']]}"
#  puts "        00000000000000000000000000"
#  DATABASE_CONFIGS[config_key] = config[ENV['MAPPER_ENV']]
#end
#puts "======================================="
#DATABASE_CONFIGS.each {|x|
#  puts x.inspect
#}

# connect active_record models
#Study.establish_connection(DATABASE_CONFIGS[:aact])
#Grant.establish_connection(DATABASE_CONFIGS[:sps])
#Organization.establish_connection(DATABASE_CONFIGS[:fdr])
#Course.establish_connection(DATABASE_CONFIGS[:ps])
#Address.establish_connection(ENV["AACT_PUBLIC_DATABASE_URL"])
#Concept.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#Hide.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#OrganizationLookup.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#OrganizationMerging.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#Overview.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#Professorship.establish_connection(DATABASE_CONFIGS[:vivo_mapper])
#ResearchInterest.establish_connection(DATABASE_CONFIGS[:vivo_mapper])


# load sdb config
SDB_CONFIG = VivoMapper::Config.load_from_file(File.join(MAPPER_ROOT,'config','sdb.yml'), ENV['MAPPER_ENV'])

# load ontologies into config
Dir.glob("#{MAPPER_ROOT}/config/ontologies/*.owl") do |ontology_file|
  SDB_CONFIG.read_ontology_file(ontology_file)
end
