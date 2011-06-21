# -*- encoding : utf-8 -*-

class ActionDispatch::Http::UploadedFile
  include Paperclip::Upfile
end

require File::dirname(__FILE__) + "/../../lib/paperclip_processors/cropper.rb"
