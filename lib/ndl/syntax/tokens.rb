module NDL::Syntax::Tokens
  Command = Struct.new :cmd, :args, :opts
  String = Struct.new :str
  Path = Struct.new :path
end
