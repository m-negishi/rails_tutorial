require 'spec_helper'

describe User do
  # beforeブロック内では、ただ属性のハッシュをnewに渡せるかどうかをテストしているだけ
  before { @user = User.new(name: "Example_User", email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

  subject{ @user }

  # Userオブジェクトがname属性を持っていない場合、beforeブロックの中で例外を投げるので、一見、これらのテストが冗長に思えるかもしれません。しかし、これらのテストを追加することで、user.nameやuser.emailが正しく動作することを保証できます
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }# 管理者権限
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  # あるオブジェクトが、真偽値を返すfoo?というメソッドに応答するのであれば、それに対応するbe_fooというテストメソッドが (自動的に)存在します。
  it { should be_valid }
  # admin?メソッドが存在しない
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      # falseからtrueへ管理者権限を変更
      @user.toggle!(:admin)
    end

    # 論理値を調べるadmin?メソッドが存在するかテスト
    it { should be_admin }
  end

  # まずユーザーのnameに無効な値 (blank) を設定し、@userオブジェクトの結果も無効になることをテストして確認
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # ユーザ名に半角スペースを許容しない
  describe "when name has some spaces" do
    before { @user.name = " test user" }
    it { should_not be_valid }
  end

  # ユーザ名に全角スペースを許容しない
  describe "when name has some spaces" do
    before { @user.name = "　test　user　" }
    it { should_not be_valid }
  end

  describe "when name has space save" do
    before { @user.name = " test user " }
    it { should_not be_valid }
  end

  # emailも同様に存在性の検証
  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  # emailの間違ったフォーマット
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  # emailの正しいフォーマット
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w(user@foo.COM A_US_ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # nameの一意性の保証(大文字小文字を区別しない)
  describe "when name is already taken" do
    before do
      user_with_same_name = FactoryGirl.create(:user, name: @user.name.upcase)
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

  # emailの一意性の保証
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # パスワードとパスワード確認が不一致のテスト
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  # パスワードが一致する場合と一致しない場合のテスト
  describe "return value of authenticate method" do
    # ユーザを保存して、findメソッドが使用できるようにする
    before { @user.save }
    # letはブロックを引数に取り、letの引数であるシンボルにそのブロックの値を返す
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      # eqはオブジェクト同士が同値であるか調べる
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      # matchしないパスワードをauthenticateメソッドに渡し、その結果(false)をletの引数に渡す
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # パスワードの長さ
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should be_invalid }
  end

  # sessionのトークンが保存されているか確認
  describe "remember token" do
    before { @user.save }

    # itsメソッドは、itと似ていますが、itが指すテストのsubject (ここでは@user) そのものではなく、引数として与えられたその属性 (この場合は:remember_token) に対してテストを行うときに使用します。
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    # let!(letバン):強制的に即座に変数を初期化する
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      # user.micropostsが正しいuserのmicropostを返しているか
      # 新しいpostと古いpostの順序を確認
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      # to_aをつけることで、オブジェクトがコピーされる(userが削除されてもコピーしたmicropostsオブジェクトは消えない)
      microposts = @user.microposts.to_a
      @user.destroy
      # コピーされたオブジェクトが消えてないか確認
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        # findメソッドだと例外が発生するので、whereメソッドを使って、nilを受け取る
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      # 与えられた要素が配列に含まれているかどうか確認
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      # フォローしてるユーザのマイクロポストが、自身のフィードに含まれているか
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    # other_userから見て、@userがフォロワーに含まれているか（逆リレーションシップ）
    describe "following" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
