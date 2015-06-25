require 'spec_helper'

describe Message do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { FactoryGirl.create(:user) }
  let(:reply_user) { FactoryGirl.create(:user) }
  before { @message = user.messages.build(content: "Lorem ipsum", in_reply_to: reply_user.id) }

  subject { @message }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:in_reply_to) }

  it { should be_valid }

  # messageのuserを返す
  describe "user methods" do
    it { should respond_to(:user) }
    its(:user) { should eq user }
  end

  describe "when user_id is not present" do
    before { @message.user_id = nil }
    it { should_not be_valid }
  end

  describe "when in_reply_to is not present" do
    before { @message.in_reply_to = '' }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { @message.content = '' }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @message.content = "a" * 141 }
    it { should_not be_valid }
  end

end
