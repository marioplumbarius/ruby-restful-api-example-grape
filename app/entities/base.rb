module Entities
  class Base < Grape::Entity
    expose :id, documentation: { type: Integer, desc: 'the id of the entity' }
    expose :created_at, documentation: { type: DateTime, desc: 'the date which the entity was created' }
    expose :updated_at, documentation: { type: DateTime, desc: 'the date which the entity was updated' }
  end
end
