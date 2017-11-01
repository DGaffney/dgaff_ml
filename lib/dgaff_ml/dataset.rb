class DGaffML
  class Dataset
    attr_accessor :dataset
    def initialize(client, dataset_response)
      @client = client
      @dataset = dataset_response
      @dataset_id = @dataset["id"]
      @user_id = @dataset["user_id"]
    end
    
    def predict(obs)
      predictions = @client.predict(@dataset_id, translate_obs(obs))
      if self.dataset["conversion_pipeline"].keys.include?("label")
        return predictions.collect{|x| self.dataset["conversion_pipeline"]["label"][x]}
      else
        return predictions
      end
    end
    
    def translate_obs(obs)
      dataset_keys = (self.dataset["conversion_pipeline"].keys-["label", "internal_headers"]).sort_by(&:to_i)
      dataset_classes = dataset_keys.collect{|k| self.dataset["col_classes"][k.to_i]}
      translated_rows = []
      obs.each do |row|
        translated_row = []
        row.each_with_index do |el, i|
          translated_row << cast_val(el, dataset_classes[i])
        end
        translated_rows << translated_row
      end
      self.convert(translated_rows, dataset_keys, dataset_classes)
    end

    def convert(rows, dataset_keys, dataset_classes)
      transposed = rows.transpose
      detexted = []
      labels = []
      transposed.each_with_index do |col, i|
        if dataset_classes[i] == "Phrase" || dataset_classes[i] == "Text"
          self.dataset["conversion_pipeline"][dataset_keys[i]]["unique_terms"].each do |term|
            counted = []
            col.each do |row|
              row = [row.to_s] if row.nil?
              counted << row.count(term)
            end
            detexted << counted
          end
        elsif dataset_classes[i] == "Categorical"
          counted = []
          col.each do |val|
            counted << self.dataset["conversion_pipeline"][dataset_keys[i]]["unique_terms"].index(val.to_s)
          end
          detexted << counted
        else
          conversion_pipeline = self.dataset["conversion_pipeline"][dataset_keys[i]]
          replaced = col.collect{|r| r||conversion_pipeline["average"]}
          dist = conversion_pipeline["max"]-conversion_pipeline["min"]
          detexted << replaced
          detexted << replaced.collect{|r| (r-conversion_pipeline["min"]).to_f/dist} if dist > 0
          detexted << replaced.collect{|r| (r-conversion_pipeline["average"]).to_f/conversion_pipeline["stdev"]} if conversion_pipeline["stdev"] > 0
          detexted << replaced.collect{|r| r.abs}
        end
      end
      return detexted.transpose
    end

    def clean_str(string)
      string.
      gsub(/[^A-Za-z0-9(),!?\'\`]/, " ").
      gsub("  ", " ").
      gsub("\'s", " \'s").
      gsub("", "").
      gsub("\'ve", " \'ve").
      gsub("n\'t", " n\'t").
      gsub("\'re", " \'re").
      gsub("\'d", " \'d").
      gsub("\'ll", " \'ll").
      gsub(",", " , ").
      gsub("!", " ! ").
      gsub("\(", " \\( ").
      gsub("\)", " \\) ").
      gsub(" \\\(  \\\(  \\\( ", " \(\(\( ").
      gsub(" \\\)  \\\)  \\\) ", " \)\)\) ").
      gsub("\?", " \? ").
      gsub(/\s{2,}/, " ").
      gsub(Regexp.new("http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"), "<URL/>").
      gsub("www", " ").
      gsub("com", " ").
      gsub("org", " ").
      strip.
      downcase
    end
    
    def cast_val(value, directive)
      if directive == "Integer"
        return value.to_i
      elsif directive == "Float"
        return value.to_f
      elsif directive == "Time"
        if value.length == 10 and value.scan(/\d/).count == 10
          return Time.at(value).to_i
        elsif value.length == 13 and value.scan(/\d/).count == 13
          return Time.at(value).to_i
        else
          return Chronic.parse(value).to_i
        end
      elsif directive == "Text" or directive == "Phrase"
        return clean_str(value).split(" ").collect{|word| Stemmer::stem_word(word)}
      elsif directive == "Categorical"
        return value
      end
    end
    
    def export_model
      @client.export_model(@dataset_id)
    end
  end
end