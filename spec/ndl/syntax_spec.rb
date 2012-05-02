# coding: utf-8

require 'spec_helper'

describe NDL::Syntax::Tokens::Command do
  subject { described_class.new(:say, ["ふー"], { :smile => true }) }
  its(:cmd) { should == :say }
  its(:args) { should == ["ふー"] }
  its(:opts) { should == { :smile => true } }
end

describe NDL::Syntax::Tokens::String do
  subject { described_class.new("ふー") }
  its(:str) { should == "ふー" }
end

describe NDL::Syntax::Tokens::Path do
  subject { described_class.new("ふー/ばー") }
  its(:path) { should == "ふー/ばー" }
end

describe do
  include NDL::Syntax

  example { Statement.parse('say "ふー"').should == Tokens::Command.new(:say, [Tokens::String.new("ふー")], {})  }
  example { Statement.parse(' say "ふー"').should == Tokens::Command.new(:say, [Tokens::String.new("ふー")], {})  }
  example { Statement.parse('say "ふー" "ばー"').should == Tokens::Command.new(:say, [Tokens::String.new("ふー"), Tokens::String.new("ばー")], {})  }
  example { Statement.parse('(say "ふー")').should == Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}) }
  example { Statement.parse(%!say "ふー"\nthink "ばー"!).should == Tokens::Command.new(:say, [Tokens::String.new("ふー")], {})  }
  example { Statement.parse('say (say "ふー")').should == Tokens::Command.new(:say, [Tokens::Command.new(:say, [Tokens::String.new("ふー")], {})], {}) }
  example { Statement.parse('<ふー/ばー>').should == Tokens::Path.new("ふー/ばー") }
  example { Statement.parse(%!{\nsay "ふー"\nthink "ばー"\n}!).should == Tokens::Document.new([Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]) }
  example { Statement.parse(%!{say "ふー"\nthink "ばー"\n}!).should == Tokens::Document.new([Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]) }
  example { Statement.parse(%!{say "ふー"\nthink "ばー"}!).should == Tokens::Document.new([Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]) }
  example { Statement.parse(%!{ say "ふー"\nthink "ばー" }!).should == Tokens::Document.new([Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]) }
  example { Statement.parse(%!{\n say "ふー"\nthink "ばー" \n}!).should == Tokens::Document.new([Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]) }
  example { Statement.parse('say --smile "ふー"').should == Tokens::Command.new(:say, [Tokens::String.new("ふー")], { :smile => true }) }
  example { Statement.parse('Pasberth say "ふー"').should == Tokens::Subject.new(:Pasberth, Tokens::Command.new(:say, [Tokens::String.new("ふー")], {})) }

  example { NDLParser.parse(%!say "ふー"\nthink "ばー"!).should == [Tokens::Command.new(:say, [Tokens::String.new("ふー")], {}), Tokens::Command.new(:think, [Tokens::String.new("ばー")], {})]  }
end