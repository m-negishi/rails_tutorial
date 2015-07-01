require 'spec_helper'

describe Conversation do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { FactoryGirl.create(:user) }
  let(:partner) { FactoryGirl.create(:user) }
  let(:conversation) { user.conversations.build(partner_id: partner.id) }

  subject { conversation }

  it { should be_valid }

  describe "conversation method" do
    it { should respond_to(:user) }
    it { should respond_to(:partner) }
    its(:user) { should eq user }
    its(:partner) { should eq partner }
  end

  # describe "when followed id is not present" do
  #   before { relationship.followed_id = nil }
  #   it { should_not be_valid }
  # end
  #
  # describe "when follower id is not present" do
  #   before { relationship.follower_id = nil }
  #   it { should_not be_valid }
  # end
end
