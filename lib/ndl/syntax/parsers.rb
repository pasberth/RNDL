require 'regparsec'
require 'ndl/syntax'
require 'ndl/syntax/tokens'

module NDL::Syntax
module Parsers
  extend RegParsec::Regparsers
  
  SkipSpaces = /((?!\n)\s)*/
  Identifier = /\w+/
  OptionalFlag = apply('--', Identifier) { |hyp, id|  [id.to_s.to_sym, true] }
  OptionalFlags = one_of(
      apply(OptionalFlag, proc { OptionalFlags }) { |a, as| [a, *as] },
      OptionalFlag,
      apply { [] } )
  Option = apply(Identifier, SkipSpaces, ':', SkipSpaces, Identifier) { |key, _ss1, _col, _ss2, val| [key.to_s.to_sym, val.to_s.to_sym] }
  Options = one_of(
    apply(Option, proc { Options }) { |a, as| [a, *as] },
    Option,
    apply { [] })
  StringLiteral = between('"', '"', /(?:(?:\\\")|[^"])*/) { |str| Tokens::String.new str.to_s }
  PathLiteral = between('<', '>', /(?:(?:\\\")|[^\>])*/) { |path| Tokens::Path.new path.to_s }
  DocumentLiteral = between(/\{\s*/, '}', many( proc { Statement } )) { |stats| Tokens::Document.new(stats) }
  RequiredArgument = apply proc { Expression }
  RequiredArguments = one_of(
      apply(RequiredArgument, SkipSpaces, proc { RequiredArguments }) { |a, _ss, as| a + as },
      RequiredArgument )
  Command = apply(Identifier, SkipSpaces, OptionalFlags, SkipSpaces, Options, SkipSpaces, RequiredArguments) {
    |cmd, _ss1, optflgs, _ss2, opts, _ss3, args|
    Tokens::Command.new cmd.to_s.to_sym, args, Hash[*(optflgs + opts).flatten]
  }
  SubjectCommand = try apply(Identifier, SkipSpaces, Command) { |sbj, _ss, cmd| Tokens::Subject.new sbj.to_s.to_sym, cmd }
  Assign = try apply(Identifier, SkipSpaces, '=', SkipSpaces, proc { Expression }) {
    |id, _ss1, eq, _ss2, exp|
    Tokens::Assignment.new(id.to_s.to_sym, exp)
  }
  Expression = one_of(
      Assign,
      SubjectCommand,
      Command,
      StringLiteral,
      PathLiteral,
      DocumentLiteral,
      between('(', ')', proc { Expression })
  )
  Statement = apply(SkipSpaces, Expression, SkipSpaces, /\n?/) { |_ss1, e, _ss2, _e| e }
  NDLParser = RegParsec::Regparser.new(Statement)
end
end

module NDL::Syntax
  include NDL::Syntax::Parsers
end