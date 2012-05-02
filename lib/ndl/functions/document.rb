module NDL

  module Functions


    class Document
  
      def initialize *texts
        @text = texts
        texts.each { |a| a.subject = self }
      end

      def out output
        output.write "%s\n" % self.as_text
      end
      
      def text
        as_text
      end
  
      def as_text
        @text.map do |t|
          t.call
          t.as_text
        end.join("\n")
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