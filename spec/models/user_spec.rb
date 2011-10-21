require 'spec_helper'

describe "user" do

  before(:all) do
    cleanup_database
    create_default_userset
  end

  it "should store geo-location" do
    user = User.first
    user.location_token = "48.2073, 14.2542"
    user.save!
    user.reload
    assert user.location[:lat] == 48.2073,
      "User's latitude should be 48.2073 but is #{user.location.inspect}"
    assert user.location[:lng] == 14.2542
      "User's longitude should be 14.2542 but is #{user.location.inspect}"
  end


end
