class Comment < ApplicationRecord
  belongs_to :refmodel, polymorphic: true
  belongs_to :user
end
