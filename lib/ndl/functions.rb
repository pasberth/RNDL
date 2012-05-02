# coding: utf-8

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

  def initialize text
    @text = try_convert_into_ndl_function! text
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
  
  def text
    @text.as_text
  end
  
  def call
  end

  def out output
    raise NotImplementedError
  end

  def as_text
    raise NotImplementedError
  end
end

require 'ndl/functions/document'
require 'ndl/functions/literals'
require 'ndl/functions/puts'