class Relationship < ActiveRecord::Base
  # Railsは外部キーを、それに対応するシンボルから推測する
  # :followerからfollower_idなど
  # しかし、Followerモデルは存在しないので、参照するクラス名を明示する必要がある
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end
