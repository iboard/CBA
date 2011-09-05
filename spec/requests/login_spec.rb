require 'spec_helper'

describe "Login" do

  describe "GET /users/sign_in" do
    it "invalid login's should show up an error" do
      get new_user_session_path
      response.body.should include("Or use an authentication provider")
    end
  end

end