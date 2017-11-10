require 'test_helper'

describe WorksController do
  describe "functions while logged in" do
    before do
      @user = users(:lindsey)
      login(@user)
    end

    describe "basic page loads" do
      it "is able to view works page" do
        get works_path
        must_respond_with :success
      end

      it "is able to view single work page" do
        work = Work.first

        get work_path(work)
        must_respond_with :success
      end

      it "can load the root path" do
        get root_path
        must_respond_with :success
      end

      it "can make new work skeleton" do
        get new_work_path
        must_respond_with :success
      end

      it "shows 404 for invalid page" do
        get work_path(98123982)
      end
    end

    describe "create" do
      it "is able to create new work" do
        params = {
          work:{
            title: "brand new title",
            creator: "bob",
            description: "brand new description",
            publication_year: 2017,
            category: "book"
          }
        }

        count = Work.count
        post works_path, params: params
        work = Work.last

        Work.count.must_equal count+1
        work.title.must_equal "brand new title"
        work.creator.must_equal "lindsey"
        work.description.must_equal "brand new description"
        work.publication_year.must_equal 2017
        work.category.must_equal "book"
      end

      it "does not create new work with missing params" do
        params = {
          work:{
            creator: "bob",
            description: "brand new description",
            category: "book"
          }
        }

        count = Work.count
        post works_path, params: params
        must_respond_with :bad_request
        Work.count.must_equal count
      end
    end

    describe "Upvote" do
      it "is able to upvote work" do
        work = Work.first
        count = Vote.count

        post upvote_path(work)

        Vote.count.must_equal count+1
        
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

    describe "Delete" do
      it "deletes a work when the creator matches" do
        work = Work.find_by(creator: 'lindsey')
        count = Work.count

        delete work_path(work)

        must_redirect_to root_path
        Work.count.must_equal count-1
      end

      it "does not delete work when creator does not match" do
        work = Work.first
        count = Work.count

        delete work_path(work)

        must_redirect_to works_path(work)
        Work.count.must_equal count
      end
    end

    describe "Update" do
      it "allows updates when creator and session match" do
        work = Work.find_by(creator: 'lindsey')

        params = {
          work:{
            title: "new title",
            creator: "lindsey",
            description: "new description",
            publication_year: 2017,
            category: "book"
          }
        }

        patch work_path(work), params: params
        must_redirect_to work_path(work.id)

        updated_work = Work.find(work.id)
        updated_work.title.must_equal "new title"
        updated_work.creator.must_equal "lindsey"
        updated_work.description.must_equal "new description"
        updated_work.publication_year.must_equal 2017
        updated_work.category.must_equal "book"
      end


      it "prevents updates when creator does not match session" do
        work = Work.first

        params = {
          work:{
            title: "new title",
            creator: "lindsey",
            description: "new description",
            publication_year: 2017,
            category: "book"
          }
        }

        patch work_path(work), params: params
        must_redirect_to work_path(work.id)

        updated_work = Work.first

        updated_work.title.must_equal work.title
        updated_work.creator.must_equal work.creator
        updated_work.description.must_equal work.description
        updated_work.publication_year.must_equal work.publication_year
        updated_work.category.must_equal work.category
      end
    end
  end

  describe "functions while not logged in" do
    describe "root" do
      it "gets root path" do
        get root_path
        must_respond_with :success
      end

    end

    describe "index" do
      it "does not get index while logged out" do
        get works_path
        must_redirect_to root_path
      end
    end

    describe "new" do
      it "does not get new page while logged out" do
        get new_work_path
        must_redirect_to root_path
      end
    end

    describe "create" do
      it "does not create new work while logged out" do
        params = {
          work:{
            title: "brand new title",
            creator: "bob",
            description: "brand new description",
            publication_year: 2017,
            category: "book"
          }
        }

        post works_path, params: params
        must_redirect_to root_path
      end
    end

    describe "show" do
      it "does not get show page while logged out" do
        work = Work.first

        get work_path(work)
        must_redirect_to root_path
      end
    end

    describe "edit" do
      it "does not get show page while logged out" do
        work = Work.first

        get edit_work_path(work)
        must_redirect_to root_path
      end

    end

    describe "update" do
      it "does not get show page while logged out" do
        work = Work.first

        params = {
          work:{
            title: "brand new title",
            creator: "bob",
            description: "brand new description",
            publication_year: 2017,
            category: "book"
          }
        }

        patch work_path(work), params: params
      end

    end

    describe "destroy" do
      it "does not get show page while logged out" do
        work = Work.first
        count = Work.count

        delete work_path(work)

        Work.count.must_equal count
        must_redirect_to root_path
      end

    end

    describe "upvote" do
      it "does not get show page while logged out" do
        work = Work.first
        count = Vote.count

        post upvote_path(work)

        must_respond_with :redirect
        must_redirect_to root_path
        Vote.count.must_equal count
      end

    end
  end
=begin
  describe "root" do
    it "succeeds with all media types" do
      # Precondition: there is at least one media of each category
      %w(album book movie).each do |category|
        Work.by_category(category).length.must_be :>, 0, "No #{category.pluralize} in the test fixtures"
      end

      get root_path
      must_respond_with :success
    end

    it "succeeds with one media type absent" do
      # Precondition: there is at least one media in two of the categories
      %w(album book).each do |category|
        Work.by_category(category).length.must_be :>, 0, "No #{category.pluralize} in the test fixtures"
      end

      # Remove all movies
      Work.by_category("movie").destroy_all

      get root_path
      must_respond_with :success
    end

    it "succeeds with no media" do
      Work.destroy_all
      get root_path
      must_respond_with :success
    end
  end

  CATEGORIES = %w(albums books movies)
  INVALID_CATEGORIES = ["nope", "42", "", "  ", "albumstrailingtext"]

  describe "index" do
    it "succeeds when there are works" do
      Work.count.must_be :>, 0, "No works in the test fixtures"
      get works_path
      must_respond_with :success
    end

    it "succeeds when there are no works" do
      Work.destroy_all
      get works_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "works" do
      get new_work_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a work with valid data for a real category" do
      work_data = {
        work: {
          title: "test work"
        }
      }
      CATEGORIES.each do |category|
        work_data[:work][:category] = category

        start_count = Work.count

        post works_path(category), params: work_data
        must_redirect_to work_path(Work.last)

        Work.count.must_equal start_count + 1
      end
    end

    it "renders bad_request and does not update the DB for bogus data" do
      work_data = {
        work: {
          title: ""
        }
      }
      CATEGORIES.each do |category|
        work_data[:work][:category] = category

        start_count = Work.count

        post works_path(category), params: work_data
        must_respond_with :bad_request

        Work.count.must_equal start_count
      end
    end

    it "renders 400 bad_request for bogus categories" do
      work_data = {
        work: {
          title: "test work"
        }
      }
      INVALID_CATEGORIES.each do |category|
        work_data[:work][:category] = category

        start_count = Work.count

        post works_path(category), params: work_data
        must_respond_with :bad_request

        Work.count.must_equal start_count
      end
    end
  end

  describe "show" do
    it "succeeds for an extant work ID" do
      get work_path(Work.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      bogus_work_id = Work.last.id + 1
      get work_path(bogus_work_id)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "succeeds for an extant work ID" do
      get edit_work_path(Work.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus work ID" do
      bogus_work_id = Work.last.id + 1
      get edit_work_path(bogus_work_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant work ID" do
      work = Work.first
      work_data = {
        work: {
          title: work.title + " addition"
        }
      }

      patch work_path(work), params: work_data
      must_redirect_to work_path(work)

      # Verify the DB was really modified
      Work.find(work.id).title.must_equal work_data[:work][:title]
    end

    it "renders bad_request for bogus data" do
      work = Work.first
      work_data = {
        work: {
          title: ""
        }
      }

      patch work_path(work), params: work_data
      must_respond_with :not_found

      # Verify the DB was not modified
      Work.find(work.id).title.must_equal work.title
    end

    it "renders 404 not_found for a bogus work ID" do
      bogus_work_id = Work.last.id + 1
      get work_path(bogus_work_id)
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "succeeds for an extant work ID" do
      work_id = Work.first.id

      delete work_path(work_id)
      must_redirect_to root_path

      # The work should really be gone
      Work.find_by(id: work_id).must_be_nil
    end

    it "renders 404 not_found and does not update the DB for a bogus work ID" do
      start_count = Work.count

      bogus_work_id = Work.last.id + 1
      delete work_path(bogus_work_id)
      must_respond_with :not_found

      Work.count.must_equal start_count
    end
  end

  describe "upvote" do
    let(:user) { User.create!(username: "test_user") }
    let(:work) { Work.first }

    def login
      post login_path, params: { username: user.username }
      must_respond_with :redirect
    end

    def logout
      post logout_path
      must_respond_with :redirect
    end

    it "returns 401 unauthorized if no user is logged in" do
      start_vote_count = work.votes.count

      post upvote_path(work)
      must_respond_with :unauthorized

      work.votes.count.must_equal start_vote_count
    end

    it "returns 401 unauthorized after the user has logged out" do
      start_vote_count = work.votes.count

      login
      logout

      post upvote_path(work)
      must_respond_with :unauthorized

      work.votes.count.must_equal start_vote_count
    end

    it "succeeds for a logged-in user and a fresh user-vote pair" do
      start_vote_count = work.votes.count

      login

      post upvote_path(work)
      # Should be a redirect_back
      must_respond_with :redirect

      work.reload
      work.votes.count.must_equal start_vote_count + 1
    end

    it "returns 409 conflict if the user has already voted for that work" do
      login
      Vote.create!(user: user, work: work)

      start_vote_count = work.votes.count

      post upvote_path(work)
      must_respond_with :conflict

      work.votes.count.must_equal start_vote_count
    end
  end
=end
end
