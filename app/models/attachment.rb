# -*- encoding : utf-8 -*-

# Attachment uses Paperclip to attach files to any model including {ContentItem}
# and embeds Attachments.
#
# For example:
#   Model {Page} (page.rb)
#     embeds_many :attachments
#     validates_associated :attachments
#     accepts_nested_attributes_for :attachments, :allow_destroy => true
#
# If the attachment's mime-type is 'image', the image will be preprocessed by imagick
# to several formats (:popup, :preview, :medium, :thumb, and :icon)
# 
# The maximum file size accepted can be configured in `application.yml` with
# :max_size_of_attachments_in_mb = 10
class Attachment

  # Where to store the files
  ASSET_PATH = File::join(Rails.root,'system')

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  has_mongoid_attached_file :file,
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

  validates_attachment_size :file,
    :less_than=>CONSTANTS['max_size_of_attachments_in_mb'].to_i.megabytes,
    :if => Proc.new { |uploaded| !uploaded.file_file_name.blank? }

  
  embedded_in :content_item, :inverse_of => :attachments, :polymorphic => true
    
end