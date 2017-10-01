require 'json'
require 'rest-client'
require 'fast-stemmer'
class DGaffML
  class Client
    def initialize(user_id)
      @user = DGaffML::Request.login(user_id)
    end
    
    def models
      DGaffML::Request.datasets(@user["id"])
    end

    def model(dataset_id)
      DGaffML::Model.new(self, DGaffML::Request.dataset(@user["id"], dataset_id))
    end
    
    def predict(dataset_id, obs)
      DGaffML::Request.predict(@user["id"], dataset_id, obs)
    end
  end
end