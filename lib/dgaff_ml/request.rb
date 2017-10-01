class DGaffML
  class Request
    def self.hostname
      "http://machinelearning.devingaffney.com"
    end
    
    def self.login(user_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}").body)
    end
    
    def self.dataset(user_id, dataset_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/dataset/#{dataset_id}").body)
    end

    def self.datasets(user_id)
      JSON.parse(RestClient.get(hostname+"/api/#{user_id}/datasets").body)
    end
    
    def self.predict(user_id, dataset_id, obs)
      JSON.parse(RestClient.post(hostname+"/api/#{user_id}/predict/#{dataset_id}", {data: obs.to_json}).body)
    end
  end
end
