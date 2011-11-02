require File::expand_path('../../spec_helper', __FILE__)

describe "Attachments for postings, pages, content_items:" do

  before(:all) do
    cleanup_database
    create_default_userset
    @blog = Blog.create(title: "News", is_draft: false)
    @posting = @blog.postings.create(title: 'First Posting', body: 'With some attachments',
      is_draft: false, is_template: false, user_id: User.first.id )
  end
  
  it "should be stored when uploaded", :js => true do
    pending "TODO: figure out how fixture_file_upload works"
    #user = User.first
    #log_in_as "admin@iboard.cc", "thisisnotsecret"
    #put( "/blogs/#{@blog.id.to_s}/postings/#{@posting.id.to_s}",
    #  "attachment_attributes[0][file]" =>  
    #  fixture_file_upload("#{Rails.root}/spec/fixtures/FileUploadText.txt", "text/plain") )
    #visit blog_posting_path(@blog,@posting)
    #click_link "Edit"
    #sleep 4
    #click_link "FileUploadText.txt"
    #page.should have_content "music is the best. Frank Zappa."
  end

end