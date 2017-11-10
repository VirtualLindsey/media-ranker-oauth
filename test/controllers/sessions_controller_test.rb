require "test_helper"

describe SessionsController do
  describe "login" do
    it "is able to login for existing user" do
      get login_path(:github)
      must_redirect_to root_path
    end

    it "works with two back to back logins" do
      get login_path(:github)
      must_redirect_to root_path

      get login_path(:github)
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "succeeds if the user is logged in" do
      get login_path(:github)
      must_redirect_to root_path

      get logout_path
      must_redirect_to root_path
    end

    it "works if user not logged in" do
      get logout_path
      must_redirect_to root_path
    end
  end
end
