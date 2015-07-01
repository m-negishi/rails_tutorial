require 'spec_helper'

describe "Message Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    visit message_path
  end

  it { should have_title('Messages') }
  it { should have_content('Messages') }

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

  # describe "pagination" do
  #   # before(:all)は一度だけ実行される
  #   before do
  #     40.times { FactoryGirl.create(:message, user: user, in_reply_to: other_user.id) }
  #     visit message_path
  #   end
  #
  #   it { should have_selector('div.pagination') }
  #
  #   it "should list each micropost" do
  #     # ページネーション
  #     user.messages.paginate(page: 1).each do |message|
  #       # expect(page).to have_selector('li', text: message.content)
  #     end
  #   end
  # end

end
