module AttachmentsHelper # :nodoc:

  def label_for_attachment(f)
    rc  = link_to( link_text(f.object), f.object.file.url(:original), :class => 'nostyle-link' )
    rc += " "
    rc += (f.object.file_file_size/1024).round.to_s
    rc += " KB, "+f.object.file_content_type
    raw rc.html_safe
  end


  private
  def link_text(object)
    if object.file_content_type =~ /image/i
      image_tag( object.file.url(:icon) ) +
        "<br /><br />".html_safe +
        object.file_file_name.truncate(80)
    else
      object.file_file_name.truncate(80)
    end
  end
end
