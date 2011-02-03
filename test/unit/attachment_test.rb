require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase

  def setup
    Posting.delete_all
    Blog.delete_all
    User.delete_all
    @user = create_valid_user_with_id('4d2ca35a2d19475c51000012')
    assert !@user.nil?, "Can't create valid user"
    @blog = Blog.create(:title => 'Test blog')
    @posting = @blog.postings.create(
      :title => 'With Attachments', 
      :body => 'Lorem', :user => @user
    )
  end

  test "A Posting should save with an attachment" do
   @posting = Blog.where(:title => 'Test blog').first.postings.first
   @posting.attachments.create
   assert @posting.save, "Posting should save with attachment"
  end
  
  test "A Page should save with an attachment" do
    @page = Page.new(:title => 'A Page with attachments', :body => 'Lorem')
    @page.attachments.create
    assert @page.save, "Page should save with attachments"
  end
    
end
