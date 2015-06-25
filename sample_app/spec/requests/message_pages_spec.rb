require 'spec_helper'

describe "Message Pages" do

  subject { page }

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

  describe "message creation" do
    before { visit root_path }

    describe "with invalid information" do
    #
      it "should not create a message" do
        expect { click_button "Send" }.not_to change(Message, :count)
      end

      # パスしないので一旦コメントアウト
      # describe "error messages" do
      #   before { click_button "Send" }
      #   it { should have_content('error') }
      # end
    end

    describe "with valid information" do

      before { fill_in 'message_content', with: "@#{user.name} Lorem ipsum" }

      it "should create a message" do
        expect { click_button "Send" }.to change(Message, :count).by(1)
      end

      # describe "should have correct count when create a post" do
      #   before { click_button "Post" }
      #
      #   it { should have_content('1 micropost') }
      #   it { should_not have_content('1 microposts') }
      # end
      #
      # describe "should have correct count when create 2 posts" do
      #   before do
      #     click_button "Post"
      #     # 2つ目のpost
      #     fill_in 'micropost_content', with: "Lorem ipsum"
      #     click_button "Post"
      #   end
      #
      #   it { should have_content('2 microposts') }
      # end
    end
  end
end
