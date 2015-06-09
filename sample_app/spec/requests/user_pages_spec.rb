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

  # ユーザindexにアクセスしたときに、各ユーザ(ログインユーザ以外も含めた)情報が表示されているか確認
  describe "index" do
    # before do
    #   sign_in FactoryGirl.create(:user)
    #   FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
    #   FactoryGirl.create(:user, name: "Ben", email: "ben@exapmle.com")
    #   visit users_path
    # end
    let(:user) { FactoryGirl.create(:user) }
    # before(:each)は、各itが実行される前に実行され、次のitが実行される前に状態等は戻る
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      # before(:all)は一度だけ実行される
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        # User.allだとレコードが多いと遅くなる
        # User.all.each do |user|
        # ページネーション
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
          # 上記はこれと同値？
          # it { should have_selector('li', text: user.name) }
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)# 最初にマッチしたdeleteリンクをクリック
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@exapmle.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    # web経由でadmin属性を変更できないことを確認
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password, password_confirmation: user.password } }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params# patchを指定することで、users#updateが呼び出される
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
