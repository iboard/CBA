# The CommentController can handle comments on polymorphic 'commentables'
class CommentsController < ApplicationController
  
  respond_to :html, :xml, :js
  
  #needed? helper_method :commentable_path
  
  def create
    @commentable = predecessors.last
    @comment = @commentable.comments.build(params[:comment])
    if @comment.valid?
      @comment.save
      @predecessors.first.save
      remember_comment
      redirect_to commentable_path
    else
      flash[:error] = t(:comment_could_not_be_saved, 
        :errors => @comment.errors.full_messages.join("<br/>")).html_safe
      redirect_to commentable_path
    end
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
    @root_object = predecessors.first
    @comment = @predecessors.last.comments.find(params[:id])
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
    @root_object = predecessors.first
    @comment = @predecessors.last.comments.find(params[:id])
    @comment.destroy
    @root_object.save
    respond_to do |format|
      format.js
      format.html { redirect_to commentable_path, :notice => t(:comment_deleted) }
    end
  end
  
  
  private
  
  def commentable_path
    path = @predecessors.map { |c| c.class.to_s.underscore }.join("_")+"_path"
    parts = @predecessors.map { |c| "'#{c.id.to_s}'" }.join(",")
    eval("#{path}(#{parts})")
  end
    
  def predecessors
    @predecessors = []
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @predecessors << $1.classify.constantize.find(value)
      end
    end
    @predecessors
  end
  
  def remember_comment
    begin
      mycomments = session[:comments] || []
      session[:comments] = mycomments.reject {|r| 
          (r[1].to_i < (Time.now-CONSTANTS['max_time_to_edit_new_comments'].to_i.minutes).to_i) ||
          r[0].to_s.eql?(@comment.id.to_s)
      } 
      session[:comments] << [@comment.id.to_s,@comment.updated_at.to_i]
    rescue => e
      Rails.logger.warn("***WARNING*** #{e.inspect} *** RESET SESSION COMMENTS #{__FILE__}:#{__LINE__}")
      session[:comments] = [@comment.id.to_s,@comment.updated_at.to_i]
    end
  end
  
end