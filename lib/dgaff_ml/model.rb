class DGaffML
  class Model
    attr_accessor :dataset
    def initialize(client, model_response)
      @client = client
      @model = model_response
      @model_id = @model["id"]
      @user_id = @model["user_id"]
    end
    
    def apply_to_new_dataset(filepath, prediction_column)
      @client.apply_to_new_dataset(@model_id, filepath, prediction_column)
    end
  end
end