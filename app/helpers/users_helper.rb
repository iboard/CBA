# -*- encoding : utf-8 -*-

module UsersHelper # :nodoc:
  
  def options_for_user_role(current=nil)
    options_for_select( (0..(User::ROLES.count-1)).map {|i| [ User::ROLES[i].to_s.humanize, i] }, current )
  end
  
  def order_link_to(field)
    params[:order]     ||= "created_at"
    params[:direction] ||= "asc"
    
    b, _b = params[:order].to_s == field.to_s ? ["<b>", "</b>"] : ["",""]
    link_to( (b+t("by_#{field.to_s}".to_sym)+_b+direction_arrow(field)).html_safe, 
      registrations_path(page: params[:page],
        order: field,
        direction: params[:direction] == "asc" ? "desc" : "asc"
      )
    )
  end
  
private
  def direction_arrow field
    if (params[:order]||"name").to_sym == field
      (params[:direction]||"asc") == "asc" ? " (^)" : " (v)" 
    else
      ""
    end
  end
end
