# coding: utf-8

require 'spec_helper'

describe NDL::Functions::Say do
  subject { described_class.new("えへへ") }
  its(:text) { should == "えへへ" }
  its(:as_text) { should == "「えへへ」" }
end

describe NDL::Functions::Think do
  subject { described_class.new("えへへ") }
  its(:text) { should == "えへへ" }
  its(:as_text) { should == "（えへへ）" }
end