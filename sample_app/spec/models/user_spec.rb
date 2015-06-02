require 'spec_helper'

describe User do
  # beforeブロック内では、ただ属性のハッシュをnewに渡せるかどうかをテストしているだけ
  before { @user = User.new(name: "Example User", email: "user@example.com") }

  subject{ @user }

  # Userオブジェクトがname属性を持っていない場合、beforeブロックの中で例外を投げるので、一見、これらのテストが冗長に思えるかもしれません。しかし、これらのテストを追加することで、user.nameやuser.emailが正しく動作することを保証できます
  it { should respond_to(:name) }
  it { should respond_to(:email) }

  # あるオブジェクトが、真偽値を返すfoo?というメソッドに応答するのであれば、それに対応するbe_fooというテストメソッドが (自動的に) 存在します。
  it { should be_valid }

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
end
