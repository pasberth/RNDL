# coding: utf-8

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
  end
end