require 'spec_helper'

describe "Message Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit message_path
  end

  it { should have_title('Message') }
  it { should have_content('Message') }

end
