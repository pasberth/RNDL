# coding: utf-8

module NDL

  module Functions

    class Puts < Function

      def call
        document.text << "%s\n" % self.as_text
      end
      
      def format text
        text = text.clone
        if subject.options[:replace_all]
          subject.options[:replace_all].each { |pat, rep| text.gsub! pat.as_text, rep.as_text }
        end
        text
      end
      
      def text
        args[0].as_text
      end
      
      def textf
        format text
      end
    end

    class Say < Puts
      
      def as_text
        "「#{textf}」"
      end
    end
    
    class Think < Puts
      
      def as_text
        "（#{textf}）"
      end
    end
    
    define_ndl_function Say
    define_ndl_function Think
  end
end
