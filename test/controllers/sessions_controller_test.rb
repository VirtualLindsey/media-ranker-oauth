require "test_helper"

describe SessionsController do
  describe "functions while logged in" do
    before do
      @user = users(:lindsey)
      login(@user)
    end

    it "is able to view works page" do
      get works_path
      must_respond_with :success
    end

    it "is able to view users page" do
      get users_path
      must_respond_with :success
    end

    it "is able to upvote work" do
      work = Work.first

      count = Vote.count
      post upvote_path(work)
      Vote.count.must_equal count+1
      must_redirect_to work_path(work)
    end

    it "prevents duplicate votes" do
      work = Work.first

      count = Vote.count
      post upvote_path(work)
      Vote.count.must_equal count+1
      must_redirect_to work_path(work)

      post upvote_path(work)
      Vote.count.must_equal count+1
    end

    
  end

  describe "functions while not logged in" do
    it "is not able to view works page" do
      get works_path
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "succeeds if the user is logged in" do
      # Gotta be logged in first
      #post login_path, params: { username: "test user" }
      #must_redirect_to root_path

      #post logout_path
      #must_redirect_to root_path
    end
  end
end
