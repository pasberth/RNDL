require 'give4each'

module NDL

  module API

    include NDL
    include NDL::Syntax

    def load_file path
      open(path) do |f|
        return Document.new(*NDLParser.parse(f.read).map(&:build_token.in(self)))
      end
    end
    
    private
      def build_token token
        case token
        when Tokens::Command
          case token.cmd
          when :say
            Functions::Say.new(*token.args.map(&:build_token.in(self)))
          when :think
            Functions::Think.new(*token.args.map(&:build_token.in(self)))
          when :replace_all
            Functions::ReplaceAll.new(*token.args.map(&:build_token.in(self)))
          else
            puts "unknown command '#{token.cmd}'"
          end
        when Tokens::String
          Functions::String.new token.str
        when Tokens::Path
          Functions::Path.new token.path
        when Tokens::Document
          Functions::Document.new(*token.stats.map(&:build_token.in(self)))
        when Tokens::Assignment
          Functions::Assign.new(token.id, build_token(token.exp))
        when Tokens::Subject
          Functions::Subject.new(token.subject, build_token(token.exp))
        end
      end
  end

  extend API
end