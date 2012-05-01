require 'regparsec'
require 'ndl/syntax'
require 'ndl/syntax/tokens'

module NDL::Syntax
module Parsers
  extend RegParsec::Regparsers
  
  SkipSpaces = /\s*/
  Identifier = /\w+/
  OptionalFlag = apply('--', Identifier) { |hyp, id|  [id.to_s.to_sym, true] }
  OptionalFlags = one_of(
      apply(OptionalFlag, proc { OptionalFlags }) { |a, as| [a, *as] },
      OptionalFlag,
      apply { [] } )
  KeywordArgument = apply Identifier, '=', proc { Expression }, &:join
  StringLiteral = between('"', '"', /(?:(?:\\\")|[^"])*/) { |str| Tokens::String.new str.to_s }
  PathLiteral = between('<', '>', /(?:(?:\\\")|[^\>])*/) { |path| Tokens::Path.new path.to_s }
  RequiredArgument = apply proc { Expression }
  RequiredArguments = one_of(
      apply(RequiredArgument, proc { RequiredArguments }) { |a, as| [a, *as] },
      RequiredArgument )
  Command = apply(Identifier, SkipSpaces, OptionalFlags, SkipSpaces, RequiredArguments) {
    |cmd, _ss1, opts, _ss2, args|
    Tokens::Command.new cmd.to_s.to_sym, args, Hash[*opts.flatten]
  }
  Expression = one_of(
      Command,
      StringLiteral,
      PathLiteral,
      apply('(', proc { Expression }, ')') { |sb, res, eb| res }
  )
  Statement = apply(Expression, /\n|.|$/) { |e, _e| e }
  NDLParser = RegParsec::Regparser.new(Statement)
end
end

module NDL::Syntax
  include NDL::Syntax::Parsers
end