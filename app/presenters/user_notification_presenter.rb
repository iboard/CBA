class UserNotificationPresenter < BasePresenter

  presents :user_notification
  
  def head
    content_tag :h3 do 
      link_to (user_notification.created_at.to_s(:short)+": "+ 
               user_notification.message.paragraphs.first + " ..."
              ), '#'
    end
  end
  
  def message_with_buttons
    content_tag :div do
      ContentItem::markdown(user_notification.message)
      buttons
    end
  end

  def message
    content_tag :div do
      ContentItem::markdown(user_notification.message)
    end
  end
  
  def buttons
    unless user_notification.hidden
      link_to( I18n.translate(:mark_read), 
        hide_notification_path(user_notification.created_at.to_i), 
        :class => 'button small')
    else
      link_to( I18n.translate(:mark_unread), 
        show_notification_path(user_notification.created_at.to_i), 
        :class => 'button small')
    end
  end


end