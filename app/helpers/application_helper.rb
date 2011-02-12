# Helpers for the entire application
# STYLE: Don't place methods here if they are used in one special controller only
#
module ApplicationHelper
  
  # yield :google_analytics will be loaded in HTML-HEAD
  def insert_google_analytics_script
    if File::exist?(
         filename=File::join(Rails.root,"config/google_analytics.head")
       )
       File.new(filename).read.html_safe
    end
  end
  
  # Return the field if current_user or the default if not
  def current_user_field(fieldname,default='')
    if user_signed_in?
      current_user.try(fieldname) || ''
    else
      default
    end
  end
  
  # See the main-layout application.html.erb where this buttons
  # will be displayed at runtime.
  def setup_action_buttons
    content_for :action_buttons do
      render :partial => '/home/action_buttons'
    end
  end
  
  # Insert a new file-field to form
  def link_to_add_fields(name,f,association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields  = f.fields_for(association,new_object, :child_index=>"new_#{association}") do |builder|
      render(association.to_s.pluralize+"/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,"add_fields(this,\"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
  # Remove an attached file
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + "&nbsp;".html_safe + link_to_function(name,"remove_fields(this)")
  end
  
  # Check if paginate is on last page
  def is_on_last_page(collection)
    collection.total_pages && (collection.current_page < collection.total_pages)
  end

  # Display errors for resource
  def errors_for(resource)
    rc = ""
    if resource.errors.any?
      rc += "<div id='error_explanation'>"+
              "<h2>"+ 
                t(:errors, :count => resource.errors.count) + ": " +
                t(:prohibited_this_resource_from_being_saved, :resource => t(resource.class.to_s.downcase.to_sym)) +
              "</h2>"+
              "<ul>" +
                 resource.errors.full_messages.map { |msg| 
                   "<li><b>"+ msg.split(" ",2)[0] + "</b>: " + msg.split(" ",2)[1] +"</li>"
                 }.join
            if defined? resource.attachments
              rc += "<ul>" + 
                    resource.attachments.map { |p|
                       p.errors.map { |error|
                         "<li>" + p.errors[error].join(", ".html_safe) + "</li>"
                       }.join
                    }.join + 
                    "</ul>"
            end
      rc += "</ul></div>"
      rc.html_safe
    end
    
  end  
end
