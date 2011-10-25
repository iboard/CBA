class UserPresenter < BasePresenter
  
  presents :user

  def location
    unless user.location_token.blank?
      content_tag :div, :class => 'user-location', :id => user.id.to_s do
        user.location_token
        javascript_tag "loadUserLocation('#{user.id.to_s}','#{user.location_token}');"
      end
    end
  end  
  
  def avatar
    link_to_function( 
      image_tag( w3c_url(user.avatar_url(:thumb) )), 
      "image_popup('#{w3c_url(user.avatar_url(:popup))}')",
      :class => 'avatar'
    )
  end
  
  def header
    content_tag( :address, :id=>"user_roles_#{user.name}") {
      user.role.to_s.humanize + ", " +
      I18n.translate(:last_login_at,:time => distance_of_time_in_words(Time.now(),user.last_sign_in_at||Time.at(0)))
    }
  end
  
  def summary
    content_tag :div, :style => 'display: block-inline; margin-left: 140px;' do
      content_tag :b, link_to( user.name, user )
      content_tag :p, authentication_icons
    end
  end
  
  def authentication_icons
    if user.authentications.any?
      content_tag( :p, :style => 'margin-left: -140px; clear: both;' ) {
        user.authentications.map { |a| 
          image_tag("/images/#{a.provider}_thirtytwo.png",:class => 'omniauth_mini_icons')
        }.join().html_safe
      }.html_safe
    end
  end
  
  def admin_buttons
    if user_signed_in? && current_user.role?(:maintainer)
      content_tag( :p,
        ui_button( 'details', I18n.translate("userlist.detail"), details_user_path(user), :remote => true) +
        ui_button( 'edit', I18n.translate(:edit_role), edit_role_user_path(user)) +
        ui_button( 'cancel', I18n.translate(:cancel_this_account), user_path(user), :confirm => t(:sure?), :method => :delete)
      ) +
      content_tag( :div, 
        :class=>'user_detail admin', 
        :id => "user_information_#{ user.id.to_s }", 
        :style => 'display: none; margin-top: 20px') {''}
    end
  end
  
end
