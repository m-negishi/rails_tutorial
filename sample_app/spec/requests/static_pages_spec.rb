# 下記エラー
# Failure/Error: it { should have_title(full_title('About'))}
    #  NoMethodError:
      #  undefined method `full_title'
# エラーここまで
include ApplicationHelper
# 上記追加
# 参考 http://yuheikagaya.hatenablog.jp/entry/2014/10/15/010935

require 'spec_helper'

describe "StaticPages" do
  # describe "GET /static_pages" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get static_pages_index_path
  #     response.status.should be(200)
  #   end
  # end

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  # pageはテストの主題 (subject) であることをRSpecに伝える
  subject { page }

  describe "Home page" do # 好きな文字列を指定できる
    before { visit root_path }

    # it "should have the content 'Sample App'" do # RSpecはダブルクオートでくくられたものは無視する
    #   # Capybaraが提供するpage変数を使って、アクセスした結果のページに正しいコンテンツが表示されているかどうか
    #   # expect(page).to have_content('Sample App')
    # end
    it { should have_content('Sample App') }
    # spec/supportディレクトリのfull_titleヘルパー
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }

    # it "should have the right title" do
    #   expect(page).to have_title("#{base_title}")
    # end
    #
    # it "should not have a custom page title" do
    #   expect(page).not_to have_title('| Home')
    # end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help')}
    it { should have_title(full_title('Help'))}
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About')}
    it { should have_title(full_title('About'))}
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact')}
    it { should have_title(full_title('Contact'))}
  end
end
