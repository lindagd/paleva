class Dish < ApplicationRecord
  has_one :item, as: :itemable
end
