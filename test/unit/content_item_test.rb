require 'test_helper'

class ContentItemTest < ActiveSupport::TestCase
  
  test "A Page sould render YOUTUBE:id and YOUTUBE_PLAYLIST:id" do
    expected_video    = "<iframe width='420' height='345' src='http://www.youtube.com/embed/Ynp-_pvoNAk' frameborder='0' allowfullscreen=''></iframe>"
    expected_playlist = "<iframe width='560' height='345' src='http://www.youtube.com/p/79963DC001C316A6?version=3&amp;hl=en_US' frameborder='0' allowfullscreen=''></iframe>"
    content_item = Page.new(title: 'Test Video Embedding', body: "Play Video YOUTUBE:Ynp-_pvoNAk</p> here \nand a Playlist YOUTUBE_PLAYLIST:79963DC001C316A6</p>")
    check = content_item.render_body
    assert check.include?(expected_video), "Body should replace YOUTUBE:id\nEXPECTED: #{expected_video}\nGOT: #{check}"
    assert check.include?(expected_playlist), "Body should replace YOUTUBE_PLAYLIST:id\nEXPECTED: #{expected_playlist}\nGOT: #{check}"
  end
  
  test "A Posting sould render YOUTUBE:id and YOUTUBE_PLAYLIST:id" do
    expected_video    = "<iframe width='420' height='345' src='http://www.youtube.com/embed/Ynp-_pvoNAk' frameborder='0' allowfullscreen=''></iframe>"
    expected_playlist = "<iframe width='560' height='345' src='http://www.youtube.com/p/79963DC001C316A6?version=3&amp;hl=en_US' frameborder='0' allowfullscreen=''></iframe>"
    content_item = Posting.new(title: 'Test Video Embedding', body: "Play Video YOUTUBE:Ynp-_pvoNAk</p> here and a Playlist YOUTUBE_PLAYLIST:79963DC001C316A6</p>")
    check = content_item.render_body
    assert check.include?(expected_video), "Body should replace YOUTUBE:id\nEXPECTED: #{expected_video}\nGOT: #{check}"
    assert check.include?(expected_playlist), "Body should replace YOUTUBE_PLAYLIST:id\nEXPECTED: #{expected_playlist}\nGOT: #{check}"
  end
  
end
