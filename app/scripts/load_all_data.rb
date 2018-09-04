require File.join(File.dirname(__FILE__),'..','..','config','environment')

DataLoader.new.load_people(:difference_import)
DataLoader.new.load_grants(:difference_import)
DataLoader.new.load_courses(:difference_import)
