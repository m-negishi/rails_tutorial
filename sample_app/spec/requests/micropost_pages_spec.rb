require 'spec_helper'

describe "MicropostPages" do
  # describe "GET /micropost_pages" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get micropost_pages_index_path
  #     response.status.should be(200)
  #   end
  # end

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "should have correct count when create a post" do
        before { click_button "Post" }

        it { should have_content('1 micropost') }
        it { should_not have_content('1 microposts') }
      end

      describe "should have correct count when create 2 posts" do
        before do
          click_button "Post"
          # 2つ目のpost
          fill_in 'micropost_content', with: "Lorem ipsum"
          click_button "Post"
        end

        it { should have_content('2 microposts') }
      end
    end
  end
  # マイクロポスト削除
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }


    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        # deleteリンクをクリックしたときに、マイクロポストのカウントが1つ減っている
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
