require 'spec_helper'

describe User do
  # beforeブロック内では、ただ属性のハッシュをnewに渡せるかどうかをテストしているだけ
  before { @user = User.new(name: "Example User", email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

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

  # あるオブジェクトが、真偽値を返すfoo?というメソッドに応答するのであれば、それに対応するbe_fooというテストメソッドが (自動的に) 存在します。
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
end
