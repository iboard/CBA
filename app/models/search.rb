class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  attr_accessor :search
  
  def initialize(attributes)
    @search = attributes[:search] || ""
  end
  
  def persisted?
    false
  end
  
  def valid?
    self.search && self.search.length >= 3
  end
  
  def result
    return @result if @result
    @result ||= Posting.fulltext_search self.search
    pages = Page.fulltext_search(self.search)
    @result << pages if pages && !pages.empty?
    @result.compact!
    @result.flatten!
    @result
  end

end
