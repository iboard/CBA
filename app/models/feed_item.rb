# -*- encoding : utf-8 -*-

# FeedItems are used to represent RSS atom items
# Used e.g. in HomeController as
#     FeedItem.new( ("%s %% %s" % [posting.title,comment.name]),
#                   comment.comment,
#                   comment.updated_at,
#                   posting_url(posting),comment)
class FeedItem

  attr_reader :title, :body, :updated_at, :url, :object

  # @param [String] title the title used for the rss-item
  # @param [String] body: the rss-item-body
  # @param [Time] updated_at:
  # @param [Object] Object any object. Appreciate if responds to :name.
  def initialize(title, body, updated_at, url, object)
    @title,@body,@updated_at,@url,@object = title, body, updated_at, url, object
  end

  # The name of the object if object respond to :name
  # or the application name as configured otherwise.
  def name
    if object.respond_to?(:name) && object.name !~ /anonymous|anonym/
      object.name
    else
      APPLICATION_CONFIG[:name]
    end
  end

  # If the user calls any method we try to delegate to our @object
  # @param [Symbol] method_sym Method to call
  # @param [Array] arguments Arguments to pass to the call.
  def method_missing(method_sym, *arguments, &block)
    object.send(method_sym,*arguments)
  end

end
