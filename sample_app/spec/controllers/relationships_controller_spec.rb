require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user, no_capybara: true }

  describe "creating a relationship with Ajax" do

    it "should icrement the Relationship count" do
      expect do
        # xhrメソッド（XmlHttpRequestの略）
        # Ajaxリクエストを発行
        # 結合テストだとxhrメソッドが使えないため、controllerのテストを分けた
        # 関連するHTTPメソッドを表すシンボル、アクションを指すシンボル、コントローラ地震にあるparamsの内容を表すハッシュのいずれかを引数に取る
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      expect(response).to be_success
      # route_defined?(relationships_path{ followed_id: other_user.id })
    end
  end

  describe "destroying a relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) do
      user.relationships.find_by(followed_id: other_user.id)
    end

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_success
    end
  end
end
