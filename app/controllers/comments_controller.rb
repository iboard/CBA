# The CommentController can handle comments on polymorphic 'commentables'
class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js
  
  helper_method :calculate_commentable_path
  
  def create
    @commentable = find_commentables.last
    @comment = @commentable.comments.build(params[:comment])
    if @comment.valid?
      @comment.save
      @commentables.first.save
      remember_comment
      redirect_to calculate_commentable_path
    else
      flash[:error] = t(:comment_could_not_be_saved, 
        :errors => @comment.errors.full_messages.join("<br/>")).html_safe
      redirect_to calculate_commentable_path
    end
  end
  
  def edit
    @form_components  = find_commentables
    @commentable = @form_components.last
    @comment = @commentable.comments.find(params[:id])
    @form_components << @comment
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  
  def update
    @root_object = find_commentables.first
    @comment = @commentables.last.comments.find(params[:id])
    @comment.comment = params[:comment][:comment]
    @comment.save    
    @new_comment = (RedCloth.new(@comment.comment).to_html.html_safe)
    respond_to do |format|
      format.js
      format.html { redirect_to calculate_commentable_path, :notice => t(:comment_successfully_updated) }
    end
  end
  
  def destroy
    @root_object = find_commentables.first
    @comment = @commentables.last.comments.find(params[:id])
    @comment.destroy
    @root_object.save
    respond_to do |format|
      format.js
      format.html { redirect_to calculate_commentable_path, :notice => t(:comment_deleted) }
    end
  end
  
  
  private
  
  def calculate_commentable_path
    path = @commentables.map { |c| c.class.to_s.underscore }.join("_")+"_path"
    parts = @commentables.map { |c| "'#{c.id.to_s}'" }.join(",")
    eval("#{path}(#{parts})")
  end
    
  def find_commentables
    @commentables = []
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentables << $1.classify.constantize.find(value)
      end
    end
    @commentables
  end
  
  def remember_comment
    session[:comments] ||= []
    session[:comments] << @comment._id
  end
end