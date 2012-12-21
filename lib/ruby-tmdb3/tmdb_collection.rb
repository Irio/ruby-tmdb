class TmdbCollection
  
  def self.find(options)
    options = {
      :expand_results => true,
      :language       => Tmdb.default_language
    }.merge(options)
    
    raise ArgumentError, "Should have: id" if(options[:id].nil?)
    
    results = []
    unless(options[:id].nil? || options[:id].to_s.empty?)
      results << Tmdb.api_call("collection", {:id => options[:id].to_s}, options[:language])
    end
    
    results.flatten!(1)
    results.uniq!
    results.delete_if &:nil?
        
    results.map!{|m| TmdbCollection.new(m, options[:expand_results], options[:language])}
    
    if(results.length == 1)
      return results.first
    else
      return results
    end
  end
  
  def self.new(raw_data, expand_results = false, language = nil)
    # expand the result by calling collection unless :expand_results is false or the data is already complete
    # (as determined by checking for the posters property in the raw data)
    if(expand_results && (!raw_data.has_key?("posters") || !raw_data['releases'] || !raw_data['cast']))
      begin
        collection_id         = raw_data['id']
        raw_data              = Tmdb.api_call 'collection', { :id => collection_id }, language
        @images_data          = Tmdb.api_call("collection/images", {:id => collection_id}, language)
        raw_data['posters']   = @images_data['posters']
        raw_data['backdrops'] = @images_data['backdrops']
      rescue => e
        raise ArgumentError, "Unable to fetch expanded infos for Collection ID: '#{collection_id}'" if @images_data.nil?
      end
    end
    return Tmdb.data_to_object(raw_data)
  end
  
  def ==(other)
    return false unless(other.is_a?(TmdbCollection))
    return @raw_data == other.raw_data
  end
    
end
