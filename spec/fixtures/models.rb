class Post < ActiveRecord::Base
  default_scope :order => "created_at ASC"
  has_and_belongs_to_many :tags
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end