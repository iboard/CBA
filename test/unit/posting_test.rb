require 'test_helper'

class PostingTest < ActiveSupport::TestCase

  def setup
    Posting.delete_all
    Blog.delete_all
    User.delete_all
    @user = create_valid_user_with_id('4d2ca35a2d19475c51000012')
    assert !@user.nil?, "Can't create valid user"
    @blog = Blog.create(:title => 'Test blog')
  end

  test "Should save if title, user, and body exists" do
    @blog = Blog.first
    @user = User.first
    p1 = @blog.postings.build(:title => "My Title", :body => 'Lorem', :user => @user)
    assert @blog.save, "Should save if title is unique"
    assert @user.postings.include?(p1), "Posting should belong to user"
  end

  test "Posting should not save without an user" do
    @blog = Blog.first
    p1 = @blog.postings.build(:title => "No User Title", :body => 'Lorem')
    assert !@blog.save, "Should not save without an user"
  end


  test "sould not save without a title and a body" do
    @blog = Blog.first
    @user = User.first
    p = @blog.postings.build(:user => @user)
    assert !p.valid?, "A posting without a title and body should not be valid"
    p.title = 'Testtitle'
    assert !p.valid?, "A posting with a title but no body should not be valid"
    p.body = 'lorem ipsum'
    assert p.valid?, "A posting with a title and a body should be valid"
  end

  # If an user choose an existing title force him to comment the
  # existing one instead of writing a new one.
  test "Title should be unique" do
    @blog = Blog.first
    @user = User.first
    p1 = @blog.postings.build(:title => "My Title", :body => 'Lorem', :user => @user)
    assert p1.save, "Should save if title is unique"

    p2 = @blog.postings.build(:title => "My Title", :body => 'Lorem', :user => @user)
    assert !p2.save, "Should not save with the same title again."
  end

  test "A Posting should save with comments" do
    @blog = Blog.first
    @user = User.first
    @blog.postings.create(:title => "My Title", :body => 'Lorem', :user => @user)
    assert @blog.save, "Blog should save with Posting"
    @blog.postings.first.comments.create( :name => 'Andi', :email => 'test@server.to', :comment => 'Cool Comment One')
    assert @blog.save, "Blog sould save with posting and comment"
  end

  test "A comment should have a body" do
    @blog = Blog.first
    @user = User.first
    @blog.postings.create(:title => "My Title", :body => 'Lorem', :user => @user)
    assert @blog.save, "Blog should save with Posting"
    @blog.postings.first.comments.create( :name => 'Andi', :email => 'test@server.to', :comment => '')
    assert !@blog.save, "Blog sould save with posting and comment"
  end

  test "A comment should not save without a name" do
    @blog = Blog.first
    @user = User.first
    @blog.postings.create(:title => "My Title A", :body => 'Lorem', :user => @user)
    assert @blog.save, "Blog should save with Posting"
    comment = @blog.postings.first.comments.create(  :email => 'test@server.to', :comment => 'Comment')
    assert !comment.save, "Comment should not save without a name"
    assert !@blog.save, "Blog sould save with a comments without a given name"
  end


end
