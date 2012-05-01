# coding: utf-8

class NDL::Function

  def initialize text
    @text = text
  end
  
  attr_reader :text

  def out output
    raise NoImplementedError
  end

  def as_text
    raise NoImplementedError
  end
end

module NDL

  module Functions

    class Puts < Function

      def out output
        output.write self.as_text
      end
    end

    class Say < Puts
      
      def as_text
        "「#{text}」"
      end
    end
    
    class Think < Puts
      
      def as_text
        "（#{text}）"
      end
    end
  end
end