# Helpers for the entire application
# STYLE: Don't place methods here if they are used in one special controller only
#
module ApplicationHelper
  
  # Return the field if current_user or the default if not
  def current_user_field(fieldname,default='')
    if user_signed_in?
      current_user.try(fieldname) || ''
    else
      default
    end
  end
end
