module Blogables
  
  def self.included(base)  
    base.extend Blogables::ClassMethods
  end
  
  class Blogable
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paperclip

    field :title
    index :title, :unique => true
    validates_presence_of :title
    validates_uniqueness_of :title

    field :body, :type => String, :required => true
    validates_presence_of :body
    
    def short_title
      title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '...')
    end    
    
    def short_title_for_url
      title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '$' )
    end
    
  end

  module ClassMethods    
  end
  
  
end