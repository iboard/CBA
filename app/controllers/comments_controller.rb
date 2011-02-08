# The CommentController can handle comments on polymorphic 'commentables'
# REVIEW: The code to handle comments with different levels of commentable SMELLS!
class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js
  before_filter :find_root_object_and_comment, :only=>[:update,:destroy]  
  def create
    @commentable = predecessors.last
    @comment, errors = Comment::build_and_validate_comment(@commentable,params[:comment])    
    if errors
      flash[:error] = t(:comment_could_not_be_saved, :errors => errors)
    else
      remember_comment
    end
    redirect_to commentable_path
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
      format.html { redirect_to commentable_path, :notice => t(:comment_successfully_updated) }
    end
  end
  
  def destroy
    @comment.destroy
    @root_object.save
    respond_to do |format|
      format.js
      format.html { redirect_to commentable_path, :notice => t(:comment_deleted) }
    end
  end
  
  
  private
  
  # build path to commentable
  # e.g.:  Blog, Posting => blog_posting_path(blog,posting)
  # e.g.:  Page          => page_path(page)
  def commentable_path
    path = predecessors.map { |c| c.class.to_s.underscore }.join("_")+"_path"
    parts = predecessors.map { |c| "'#{c.id.to_s}'" }.join(",")
    eval("#{path}(#{parts})")
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
    begin
      mycomments = session[:comments] || []
      session[:comments] = mycomments.reject { |r| 
          (r[1].to_i < (Time.now-CONSTANTS['max_time_to_edit_new_comments'].to_i.minutes).to_i) ||
          r[0].to_s.eql?(@comment.id.to_s)
      } 
      session[:comments] << [@comment.id.to_s,@comment.updated_at.to_i]
    rescue => e
      Rails.logger.warn(  "***WARNING*** #{e.inspect} *** "+
                          "RESET SESSION COMMENTS "+
                          "#{__FILE__}:#{__LINE__}"
                       )
      session[:comments] = [@comment.id.to_s,@comment.updated_at.to_i]
    end
  end
  
  
  def find_root_object_and_comment
    @root_object = predecessors.first
    @comment = predecessors.last.comments.find(params[:id])
  end
end