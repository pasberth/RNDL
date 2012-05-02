require 'give4each'
require 'clamp'

module NDL::CLI
  
  class Main < Clamp::Command
    
    parameter "NAME", "the ndl file path", :attribute_name => :name

    def execute
      NDL.load_file(name).out($stdout)
    end
  end
end