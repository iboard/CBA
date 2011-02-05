module CoverPicture
  
  def self.included(base)  
    base.extend CoverPicture::ClassMethods
  end
  
  module ClassMethods
    def has_cover_picture
      class_eval <<-EOV
        include Mongoid::Paperclip
        has_attached_file :cover_picture,
                          :styles => { 
                            :popup  => "800x600=",
                            :medium => "300x500>",
                            :thumb  => "100x150>",
                            :icon   => "64x90"
                          }
        # check if a picture exists. If you call <code>paperclip_field.url(:mode)</code>
        # paperclip will return <code>.../missing.png</code> at least and this is
        # always true. Use <code>cover_picture_exists?</code> to check if there
        # is a real picture there.
        def cover_picture_exists?
          cover_picture && !cover_picture.original_filename.blank?
        end
      EOV
    end
    
  end
end