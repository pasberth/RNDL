require 'clamp'

module NDL::CLI
  
  class Main < Clamp::Command
    
    parameter "NAME", "the ndl file path", :attribute_name => :name

    def execute
      puts NDL.load_file(name).map(&:as_text)
    end
  end
end