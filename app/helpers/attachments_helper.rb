module AttachmentsHelper # :nodoc:

  def label_for_attachment(f)
    rc =  "<b>"
    rc +=   link_to( f.object.file_file_name, f.object.file.url(:original) )
    rc +=   " "
    rc +=   (f.object.file_file_size/1024).round.to_s
    rc +=   " KB, "+f.object.file_content_type
    rc += "</b>"
    rc
  end

end
