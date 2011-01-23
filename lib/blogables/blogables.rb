# The Blogable-class within this module can be used to make any model in
# your application to be 'blogabble'. Just derive from Blogables::Blogable
module Blogables
  
  def self.included(base)  
    base.extend Blogables::ClassMethods
  end
  
  
  # == Blogable
  # Can be a 'Page', a 'Posting' or something else you want to be
  # * Commentable
  # * Rateable
  # * Able to display in RSS-feeds
  # * and more.
  #
  # Please note that you should use <code>stored_in :your_collection_name</code>
  # in your derived class. Otherwise Mongo will store all blogables in
  # one single collection named 'blogables_blogables' and properly this
  # will not what you will do. Thou it can make sense in some cases.
  class Blogable
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paperclip

    # Blogables should have a unique title
    field :title
    index :title, :unique => true
    validates_presence_of :title
    validates_uniqueness_of :title

    # Blogables always have a body thou this body will be rendered in 
    # different ways by derived classes.
    field :body, :type => String, :required => true
    validates_presence_of :body
    
    # Will return a truncated version of the title if it exceeds the maximum
    # length of titles used in the menu (or wherever you can't display long titles)
    def short_title
      title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '...')
    end    
    
    # Same as short_title but will append a $-sign instead of '...'
    # ... smells in URLs and one can not see the difference if ... is just
    # part of the title or comes from truncation.
    def short_title_for_url
      title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '$' )
    end
    
  end

  module ClassMethods # :nodoc:
  end
  
  
end