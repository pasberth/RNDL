# coding: utf-8

require 'active_support/core_ext/string/inflections' # for underscore

module NDL::FunctionHelpers
  def try_convert_into_ndl_function! obj
    case obj
    when NDL::Function then obj
    when ::String then NDL::Functions::String.new obj
    else raise TypeError, "Can't convert #{obj.class} into NDL::Function"
    end
  end
end

class NDL::Function
  
  include NDL::FunctionHelpers

  def initialize *args
    @args = args.map &:try_convert_into_ndl_function!.in(self)
    @options = {}
  end
  
  def document
    @document ||= ::NDL::Functions::Document.new 
  end
  
  def document= doc
    @document = doc
  end

  def subject
    @subject ||= document
  end
  
  def subject= sbj
    @subject = sbj
  end
  
  attr_accessor :args, :options
  
  def call
  end

  def as_text
    raise NotImplementedError
  end
end

module NDL::Functions
  
  extend self
  
  def ndl_functions
    @ndl_functions ||= {}
  end

  def define_ndl_function ndl_function_class, id = ndl_function_class.name.sub(/^#{Regexp.quote self.name + '::'}/, '').underscore
    ndl_functions[id.to_sym] = ndl_function_class
  end
end

require 'ndl/functions/document'
require 'ndl/functions/literals'
require 'ndl/functions/puts'