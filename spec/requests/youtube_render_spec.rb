require File::expand_path('../../spec_helper', __FILE__)

describe "YOUTUBE-Videos" do
   
  before(:all) do
    cleanup_database
    create_default_userset
    @expected_video    = Regexp.new Regexp.escape('<iframe width="420" height="345" src="http://www.youtube.com/embed/Ynp-_pvoNAk" frameborder="0" allowfullscreen=""></iframe>')
    @expected_playlist = Regexp.new Regexp.escape('<iframe width="560" height="345" src="http://www.youtube.com/p/79963DC001C316A6?version=3&amp;hl=en_US" frameborder="0" allowfullscreen=""></iframe>')
  end

  it "should be rendered within pages" do
    _page = Page.create(title: 'Test Video Embedding', 
      body: "Play Video YOUTUBE:Ynp-_pvoNAk</p> here \nand a Playlist YOUTUBE_PLAYLIST:79963DC001C316A6</p>",
      user_id: User.first.id, is_draft: false, is_template: false)
    visit page_path(_page.id)
    assert page.html.should match @expected_video
    assert page.html.should match @expected_playlist
  end
  
  it "should be rendered within postings" do
    blog = Blog.create title: 'News', is_draft: false
    posting = blog.postings.create title: 'For user only', 
      body: "Play Video YOUTUBE:Ynp-_pvoNAk</p> here and a Playlist YOUTUBE_PLAYLIST:79963DC001C316A6</p>",
      is_draft: false, user: User.first
    visit posting_path(posting)
    assert page.html.should match @expected_video
    assert page.html.should match @expected_playlist
  end

end