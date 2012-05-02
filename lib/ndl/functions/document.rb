module NDL

  module Functions


    class Document < Function
  
      def initialize *texts
        @texts = texts
        @texts.each { |a| a.document = self; a.subject = self }
      end
      
      def call
        @texts.each &:call
        nil
      end
      
      def text
        @text or (@text = ''; call; @text)
      end
  
      def as_text
        text
      end
      
      def permanents
        @permanents ||= {}
      end
      
      def options
        @options ||= {}
      end
    end

    ::NDL::Document = Document
    
    class Assign < Function

      def initialize id, exp
        @id = id
        @exp = exp
      end
      
      def call
        subject.permanents[@id] = @exp
      end
    end
    
    class Subject < Function
      
      def initialize id, exp
        @id = id
        @exp = exp
      end
      
      def call
        sbj = subject.permanents[@id] or fail
        @exp.document = self.document
        @exp.subject = sbj
        @exp.call
      end
    end

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