class Attachment

  ASSET_PATH = File::join(Rails.root,'system')

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  cache

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

  embedded_in :content_item, :inverse_of => :attachments

end