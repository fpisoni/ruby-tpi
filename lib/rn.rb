module RN
  autoload :VERSION, 'rn/version'
  autoload :Commands, 'rn/commands'

  #classes
  class_path = 'rn/classes'
  autoload :RNFile, "#{class_path}/RNFile"
  autoload :Note, "#{class_path}/Note"
  autoload :Book, "#{class_path}/Book"

  #modules  
  mod_path = 'rn/modules'
  autoload :Errors, "#{mod_path}/errors"
  autoload :Paths, "#{mod_path}/paths"
  autoload :FileUtils, "#{mod_path}/file_utils"
end
