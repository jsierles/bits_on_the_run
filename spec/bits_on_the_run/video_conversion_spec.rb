require File.dirname(__FILE__) + '/../spec_helper'
include BitsOnTheRun

describe Video do
  before(:each) do
    Initializer.run do |config|
      config.api_key    = 'api key'
      config.api_secret = 'api secret'
    end
  end

  after(:each) do
    Configuration.api_key    = nil
    Configuration.api_secret = nil
  end

  describe "Getting a video conversion from the API (/videos/conversions/show)" do
    before(:each) do
      client = Client.new('/some/action')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response>
        <status>ok</status>
        <conversion key="SjwIOMZV">
          <filesize>639173</filesize>
          <link>
            <protocol>http</protocol>
            <address>content.bitsontherun.com</address>
            <path>/originals/BvbnBjB6-b6a73a2b.mp4</path>
          </link>
          <status>Ready</status>
          <template id="50" />
        </conversion>
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @conversion = VideoConversion.show("SjwIOMZV")
    end

    it "should return a video conversion instance" do
      @conversion.should be_a(VideoConversion)
    end

    it "should have the conversion key supplied by the API" do
      @conversion.key.should == "SjwIOMZV"
    end

    it "should have the filesize '639173'" do
      @conversion.file_size.should == 639173
    end

    it "should have the template_id '50'" do
      @conversion.template_id.should == 50
    end

  end

  describe "Deleting a video conversion from the API (/videos/conversions/delete)" do
    before(:each) do
      client = Client.new('/some/action')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <response>
          <status>ok</status>
        </response>
      XML
      Client.stub!(:new).and_return(client)
      @status = VideoConversion.delete!("yYul4DRz")
    end
  
    it "should return status 'ok'" do
      @status.should == "ok"
    end
  
  end
  
  describe "Creating a video conversion from the API (/videos/conversions/create) " do
    before(:each) do
      client = Client.new('/some/action')
      client.stub!(:response).and_return REXML::Document.new <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response>
        <status>ok</status>
        <conversion key="O7oHKFgm" />
      </response>
      XML
      Client.stub!(:new).and_return(client)
      @conversion = VideoConversion.create!("O7oHKFgm", 50)     
    end
 
    it "should return status 'ok'" do      
      @conversion.should == "ok"
    end
    
  end
  
end
