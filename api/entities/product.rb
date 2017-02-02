module API
  module Entities
    class Product < Grape::Entity
      expose :id
      expose :name
      expose :color
      expose :sku
    end
  end
end
