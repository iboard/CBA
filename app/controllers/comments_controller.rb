# The CommentController can handle comments on polymorphic 'commentables'
# REVIEW: The code to handle comments with different levels of commentable SMELLS!
class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js
  before_filter :find_root_object_and_comment, :only=>[:update,:destroy,:show]  
  
  def create
    if can? :create, Comment
      @commentable = predecessors.last
      @comment, errors = Comment::build_and_validate_comment(@commentable,params[:comment])    
      if errors
        flash[:error] = t(:comment_could_not_be_saved, :errors => errors).html_safe
      else
        remember_comment
      end
      notice = nil
    else
      notice = t(:access_denied)
    end
    redirect_to commentable_path, :alert => notice
  end
  
  def edit
    @form_components  = predecessors
    @commentable = @form_components.last
    @comment = @commentable.comments.find(params[:id])
    @form_components << @comment
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def update
    unless params[:commit] == t(:cancel)
      @comment.comment = params[:comment][:comment]
      remember_comment
      @comment.save
    end
    @new_comment = (RedCloth.new(@comment.comment).to_html.html_safe)
    respond_to do |format|
      format.js
      format.html { redirect_to commentable_path, :notice => t(:comment_successfully_updated).html_safe }
    end
  end
  
  def destroy
    @redirect_path = commentable_path
    @comment.destroy
    @root_object.save
    respond_to do |format|
      format.js { 
        render :destroy
        return
      }
      format.html { redirect_to commentable_path, :notice => t(:comment_deleted) }    
    end
  end
  
  
  private
  
  # build path to commentable
  # e.g.:  Blog, Posting => blog_posting_path(blog,posting)
  # e.g.:  Page          => page_path(page)
  def commentable_path
    eval("%s(%s)" % find_path_and_parts)
  end
    
  # Collect predecessors from router-path
  # e.g /blog/:blog_id/postings/:postings_id/comments ....
  #     predecessors => Blog, Posting
  # e.g /page/:page_id/comments
  #     predecessors => Page
  def predecessors
    return @predecessors if defined?(@predecessors)
    @predecessors = []
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @predecessors << $1.classify.constantize.find(value)
      end
    end
    @predecessors
  end
  
  
  # Save comment_ids with timestamps in session[:comments]
  # Will be used in Ability.rb to check if comment can be edited.
  def remember_comment
    session[:comments] = @comment.update_session_comments(session[:comments])
  end
  
  def find_path_and_parts
    path = predecessors.map { |p| p.class.to_s.underscore }.join("_")+"_path"
    parts = predecessors.map { |c| "'#{c.id.to_s}'" }.join(",")
    [path, parts]
  end
  
  def find_root_object_and_comment
    @root_object = predecessors.first
    @comment = predecessors.last.comments.find(params[:id])
  end
  
end