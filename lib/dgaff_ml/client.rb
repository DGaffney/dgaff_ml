require 'chronic'
require 'json'
require 'rest-client'
require 'fast-stemmer'
class DGaffML
  class Client
    def initialize(user_id)
      @user = DGaffML::Request.login(user_id)
    end

    def datasets
      DGaffML::Request.datasets(@user["id"]).collect{|d| DGaffML::Dataset.new(self, d)}
    end

    def dataset(dataset_id)
      DGaffML::Dataset.new(self, DGaffML::Request.dataset(@user["id"], dataset_id))
    end

    def export_model(dataset_id)
      DGaffML::Model.new(self, DGaffML::Request.export_model(@user["id"], dataset_id))
    end

    def models
      DGaffML::Request.models(@user["id"]).collect{|m| DGaffML::Model.new(self, m)}
    end

    def model(model_id)
      DGaffML::Model.new(self, DGaffML::Request.model(@user["id"], model_id))
    end

    def predict(dataset_id, obs)
      DGaffML::Request.predict(@user["id"], dataset_id, obs)
    end
    
    def apply_to_new_dataset(model_id, filepath, prediction_column)
      DGaffML::Dataset.new(self, DGaffML::Request.apply_to_new_dataset(@user["id"], model_id, filepath, prediction_column))
    end
    
    def new_dataset(filepath, prediction_column)
      DGaffML::Dataset.new(self,DGaffML::Request.new_dataset(@user["id"], filepath, prediction_column))
    end
  end
end