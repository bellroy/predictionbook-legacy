#Dir['lib/**/*_ext.rb'].map(&method(:require))
# In order for Rails3 to auto load my class, the class name should be compliant to the file name and the folder structure
Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].map(&method(:require))
