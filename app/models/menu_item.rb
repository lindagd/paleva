class MenuItem < ApplicationRecord
  belongs_to :establishment
  delegated_type :itemable, types: %w[ Dish ]
end
