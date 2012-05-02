# coding: utf-8

module NDL::FunctionHelpers
  def try_convert_into_ndl_function! obj
    case obj
    when NDL::Function then obj
    when ::String then NDL::Functions::String.new obj
    else raise TypeError, "Can't convert #{obj.class} into NDL::Function"
    end
  end
end

class NDL::Function
  
  include NDL::FunctionHelpers

  def initialize text
    @text = try_convert_into_ndl_function! text
  end
  
  def text
    @text.as_text
  end

  def out output
    raise NoImplementedError
  end

  def as_text
    raise NoImplementedError
  end
end

module NDL

  module Functions

    class String < Function
      
      def initialize text=""
        @text = text
      end

      def text
        as_text
      end

      def as_text
        @text
      end
    end
    
    class Path < Function
      
      def initialize path
        @text = path
      end
      
      def text
        as_text
      end

      def as_text
        @body ||= open @text, &:read
      end
    end

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