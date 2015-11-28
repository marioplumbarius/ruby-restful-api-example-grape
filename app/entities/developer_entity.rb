module Entities
  class Developer < Entities::Base
    expose :name, documentation: { type: String, desc: 'the name of the developer' }
    expose :age, documentation: { type: Integer, desc: 'the age of the developer' }
    expose :github, documentation: { type: String, desc: 'the github url of the developer' }
  end
end
