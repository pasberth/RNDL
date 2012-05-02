module NDL::Syntax::Tokens
  Command = Struct.new :cmd, :args, :opts
  String = Struct.new :str
  Path = Struct.new :path
  Subject = Struct.new :subject, :exp
  Document = Struct.new :stats
  Assignment = Struct.new :id, :exp
end
