require 'clamp'

module NDL::CLI
  
  class Main < Clamp::Command
    
    parameter "NAME", "the ndl file path", :attribute_name => :name

    def execute
      open(name) do |f|
        puts ::NDL::Syntax::NDLParser.parse(f.read)
      end
    end
  end
end