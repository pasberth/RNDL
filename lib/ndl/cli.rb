require 'clamp'

module NDL::CLI
  
  class Main < Clamp::Command
    
    parameter "NAME", "the ndl file path", :attribute_name => :name

    def execute
      NDL.load_file(name).each &:out.with($stdout)
    end
  end
end