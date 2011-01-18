class CommentsController < ApplicationController
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment][:comment])
    if @comment.valid?
      @comment.save
      @commentable.save
      redirect_to @commentable
    else
      flash[:error] = t(:comment_could_not_be_saved, 
        :errors => @comment.errors.full_messages.join("<br/>")).html_safe
      redirect_to redirect_path
    end
  end
  
  
  private
  
  def redirect_path
    eval("#{@commentable.class.to_s.underscore}_path(@commentable, "+
         ":comment => params[:comment][:comment])")
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
end