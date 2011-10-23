$(document).ready ->
  $('#user_notifications').dialog({ closeText: 'hide', dialogClass: 'alert', modal: true, width: 700, title: 'Messages' })  
  $('#user_notifications').accordion()
  $('#user-notification-list').accordion()
