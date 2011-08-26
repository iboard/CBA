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
  
  # Don't start search if we have not 3 chars at least.
  def valid?
    self.search && self.search.length >= 3
  end
  
  # Note: Since we use :index_name => 'site_search' for each model
  # this search will find entries of any model, not just Page!
  def result
    @result ||= Page.fulltext_search(self.search, { :return_scores => true })
  end

end
