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

    @result = []

    [Page,Posting].each do |ressource|
      found = ressource.fulltext_search(self.search)
      Rails.logger.info("    FOUND #{found.count} ITEMS")
      @result += [found] if found && !found.empty?
    end

    @result.compact!
    @result.flatten!
    @result
  end

end
