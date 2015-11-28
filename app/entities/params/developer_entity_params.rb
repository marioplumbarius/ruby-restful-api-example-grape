module Entities
  module Params
    class Developer < Entities::Developer
      unexpose :id
      unexpose :created_at
      unexpose :updated_at
    end
  end
end
