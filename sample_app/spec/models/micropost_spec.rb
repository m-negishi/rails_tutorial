require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  # Micropost.create => user.microposts.create
  # Micropost.create! => user.microposts.create!
  # Micropost.new => user.microposts.build
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:in_reply_to) }
  # micropost.userが返ってくるか
  it { should respond_to(:user) }
  # FactoryGirlで作成したuserが、micropost.userと同じか
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = '' }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "with reply content is present" do
    before do
      @micropost.content = "@#{@micropost.user.name} reply test"
    end

    it { should be_valid }
  end
end
