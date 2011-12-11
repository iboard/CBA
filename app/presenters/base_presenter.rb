class BasePresenter
  
  attr_reader   :object
  attr_accessor :interpreter
  
  def initialize(object, template)
    @object     = object
    @template   = template
  end
    
private
  def self.presents(name)
    define_method(name) do
      @object
    end
  end
  
  def h
    @template
  end
  
  def markdown(text)
    Redcarpet.new(text, :hard_wrap, :filter_html, :autolink).to_html.html_safe
  end
  
  # Replace blanks by %20 to satisfy w3c-validators
  def w3c_url(url)
    url.gsub(' ', '%20')
  end
  
  def method_missing(*args, &block)
    @template.send(*args,&block)
  end
  
end