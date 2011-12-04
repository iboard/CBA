# Present an {Attachment}
class AttachmentPresenter < BasePresenter
  
  # What to present
  presents :attachment
    
  # render the image with a link to open a larger view in a popup-div if content_type is image
  # otherwise render a link to download the file.
  def image_or_link
    if attachment.file.content_type =~ /image/
      link_to_function( h.image_tag( w3c_url(attachment.file.url(:icon)) ), "image_popup('#{attachment.file.url(:popup)}')")
    else
      link_button attachment.file.original_filename, "button download small", attachment.file.url()
    end
  end
end