module NDL

  module Functions


    class Document
  
      def initialize *texts
        @texts = texts
        @texts.each { |a| a.subject = self }
      end
      
      def call
        @texts.each &:call
        nil
      end
      
      def text
        @text ||= ''
      end
  
      def as_text
        text
      end
      
      def options
        @options ||= {}
      end
    end

    ::NDL::Document = Document
    
    class ReplaceAll < Function
      
      def initialize pattern, replacement
        @pattern = pattern
        @replacement = replacement
      end
      
      def call
        (subject.options[:replace_all] ||= []).unshift [@pattern, @replacement]
      end
      
      def as_text
        # TODO
        'TODO: Do the Functions::ReplaceAll return what.'
      end
    end
  end
end