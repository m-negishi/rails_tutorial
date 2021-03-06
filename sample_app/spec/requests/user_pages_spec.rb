include ApplicationHelper
require 'spec_helper'

# describe "UserPages" do
#   describe "GET /user_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get user_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end

describe "Users pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        # changeメソッドは、オブジェクトとシンボルを引数にとる
        # シンボルに該当するメソッドを呼び出す
        expect { click_button submit }.not_to change(User, :count)
        # 上記は以下と同等のコード
        # initial = User.count
        # click_button "Create my account"
        # final = User.count
        # expect(initial).to eq final
      end

      # エラーメッセージのテスト
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        # フォームに値を入れる
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        # カウントが1つ増えることを確認
        expect { click_button submit }.to change(User, :count).by(1)
      end

      # createアクションでユーザが保存された後の動作をテスト
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        # have_selectorメソッドは、特定のCSSクラスに属する特定のHTMLタグが存在するかテスト
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
