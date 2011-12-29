jQuery ->
  calendar_publish = $('#page_publish_at_date')
  if calendar_publish
    calendar_publish.datepicker({ dateFormat: 'yy-mm-dd'})
    calendar_publish.datepicker({ gotoCurrent: true })
    calendar_publish.datepicker({ showAnim: 'fold' })
    calendar_publish.datepicker({ showButtonPanel: true })
  calendar_expire = $('#page_expire_at_date')
  if calendar_expire
    calendar_expire.datepicker({ dateFormat: 'yy-mm-dd'})
    calendar_expire.datepicker({ gotoCurrent: true })
    calendar_expire.datepicker({ showAnim: 'fold' })
    calendar_expire.datepicker({ showButtonPanel: true })