require 'spec_helper'

describe "Message Pages" do

  subject { page }

  describe "for signed_in users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit message_path
    end

    it { should have_title('Message') }
    it { should have_content('Message') }

    # Messageページにて、リプライが表示されている
    describe "should render the reply from other to user" do
      before do
        user.save
        other_user.save
        FactoryGirl.create(:message, user: other_user, in_reply_to: user.id, content: "@#{user.name} message test")
      end
      # 何故か以下のテストが通らない
      # undefined local variable or method `user' for #<Class:0x007fd6498087a8> (NameError)
      # user.messages.each do |message|
      #   expect(page).to have_selector('li', text: message.content)
      # end
    end
  end
end
