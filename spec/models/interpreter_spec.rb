require 'spec_helper'

describe "Interpreter should render keywords" do
  
  before(:all) do
    class TestObject
      def title
        "TESTOBJECT's Title"
      end
      def body
        "TESTOBJECT's Body"
      end
    end
    @testobject = TestObject.new
    
    class TestObjectWithAttachment < TestObject
      def attachments
        [
          Attachment.new,
          Attachment.new
        ]
      end
    end
    @testobject_with_attachments = TestObjectWithAttachment.new
      
  end
  
  it "should replace TITLE" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("My title is TITLE") =~ /TESTOBJECT's Title/, "Title should be replaced"
  end
  
  it "should replace BODY" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("My title is my BODY") =~ /TESTOBJECT's Body/, "Body should be replaced"
  end
  
  it "should replace ATTACHMENT:n" do    
    interpreter = Interpreter.new(@testobject_with_attachments)
    assert interpreter.render("Render an ATTACHMENT:1 here") =~ /CAN'T DISPLAY ATTACHMENTS WITHOUT PRESENTER/, "Should display ATTACHMENT!"
  end
  
  it "should replace YOUTUBE:x" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("Render an YOUTUBE:xxx here") =~ /iframe.*youtube.com.*xxx/i, "Should display Youtube-iframe!"
  end
  
  it "should replace YOUTUBE_PLAYLIST:x" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("Render an YOUTUBE_PLAYLIST:xxx here") =~ /iframe.*youtube.com.*xxx/i, "Should display Youtube-iframe!"
  end
  
  it "should replace PLUSONE" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("Render an PLUSONE here") =~ /g:plusone size/i, "Should display G+ button"
  end
  
  it "should replace LOCATION" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("Render an [LOCATION:1,2]") =~ /open-location/, "Should have a link to open map"
  end

  it "should replace PLACE" do
    interpreter = Interpreter.new(@testobject)
    assert interpreter.render("Render an [PLACE:Technisches Museum, Wien]") =~ /open-place/, "Should have a link to open map"
  end  
  
end
