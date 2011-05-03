class FeedItem

  attr_reader :title, :body, :updated_at, :url, :object

  def initialize(title, body, updated_at, url, object)
    @title,@body,@updated_at,@url,@object = title, body, updated_at, url, object
  end

  def name
    if object.respond_to?(:name) && object.name !~ /anonymous|anonym/
      object.name
    else
      APPLICATION_CONFIG[:name]
    end
  end

  def method_missing(method_sym, *arguments, &block)
    object.send(method_sym,*arguments)
  end
end