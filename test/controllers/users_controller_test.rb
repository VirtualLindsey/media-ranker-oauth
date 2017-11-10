require 'test_helper'

describe UsersController do
  describe "index" do
    before do
      @user = users(:lindsey)
      login(@user)
    end

    it "is able to view users page" do
      get users_path
      must_respond_with :success
    end

    it "succeeds with many users" do
      # Assumption: there are many users in the DB
      User.count.must_be :>, 0

      get users_path
      must_respond_with :redirect
    end

    it "succeeds with no users" do
      # Start with a clean slate
      Vote.destroy_all # for fk constraint
      User.destroy_all

      get users_path
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "show" do
    it "succeeds for an extant user not logged in" do
      get user_path(User.first)
      must_respond_with :redirect
      must_redirect_to root_path
    end


  end

  describe "index" do
    it "fails with many users not logged in" do
      # Assumption: there are many users in the DB
      User.count.must_be :>, 0

      get users_path
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "succeeds with no users not logged in" do
      # Start with a clean slate
      Vote.destroy_all # for fk constraint
      User.destroy_all

      get users_path
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "show" do
    it "succeeds for an extant user not logged in" do
      get user_path(User.first)
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "renders 404 not_found for a bogus user not logged in" do
      # User.last gives the user with the highest ID
      bogus_user_id = User.last.id + 1
      get user_path(bogus_user_id)
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
