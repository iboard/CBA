class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  has_attached_file :file,
                    :styles => lambda { |attachment| 
                      if attachment.instance_read(:content_type) =~ /image/
                        {  
                           :popup  => "800x600=",
                           :preview => "450x325=",
                           :medium => "300x300>",
                           :thumb  => "100x100>",
                           :icon   => "64x64" 
                        } 
                      else 
                        {} 
                      end 
                    } 
  
  embedded_in :content_item, :inverse_of => :attachments
  
end