class DGaffML
  class Request
    def self.hostname
      "http://machinelearning.devingaffney.com"
    end

    def self.login(user_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}").body)
    end
    
    def self.new_dataset(user_id, filepath, prediction_column)
      JSON.parse(RestClient.post(hostname+"/api/#{user_id}/new_dataset", {csv_data: CSV.read(filepath), prediction_column: prediction_column}).body)
    end

    def self.dataset(user_id, dataset_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/dataset/#{dataset_id}").body)
    end

    def self.datasets(user_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/datasets").body)
    end
    
    def self.export_model(user_id, dataset_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/dataset/#{dataset_id}/export_model").body)
    end

    def self.model(user_id, model_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/model/#{model_id}").body)
    end

    def self.models(user_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/models").body)
    end

    def self.apply_to_new_dataset(user_id, model_id, filepath, prediction_column)
    binding.pry
      JSON.parse(RestClient.post(hostname+"/api/#{user_id}/model/#{model_id}/apply_to_new_dataset", {filesize: File.open(filepath).size/1024.0/1024, filename: filepath.split("/").last, csv_data: CSV.read(filepath).to_json, prediction_column: prediction_column}).body)
    end

    def self.predict(user_id, dataset_id, obs)
      JSON.parse(RestClient.post(hostname+"/api/#{user_id}/predict/#{dataset_id}", {data: obs.to_json}).body)
    end

  end
end
