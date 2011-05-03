require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase

  test "FeedItem should initialize and keep params" do
    ts = Time.now
    item = FeedItem.new("An Item", "with a wonderful body", ts, "http://example.com", nil )
    assert item.title.eql?("An Item"), 'Item title should be stored'
    assert item.body.eql?("with a wonderful body"), 'Item body should be stored'
    assert item.updated_at.eql?(ts), 'Updated at should be stored'
    assert item.url.eql?("http://example.com"), 'URL should be stored'
  end

end

