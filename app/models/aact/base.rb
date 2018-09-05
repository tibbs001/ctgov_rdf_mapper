module Aact
  class Base < ActiveRecord::Base
    establish_connection(ENV["AACT_DATABASE_URL"])
    self.abstract_class = true
  end
end
