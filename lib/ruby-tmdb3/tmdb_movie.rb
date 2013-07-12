class TmdbMovie
  
  def self.find(options)
    options = {
      :expand_results => true,
      :language       => Tmdb.default_language,
      :search_type    => Tmdb.default_search_type
    }.merge(options)

    if options[:id].nil? && options[:title].nil? && options[:imdb].nil?
      raise ArgumentError, 'At least one of: id, title, imdb should be supplied'
    end

    results = []

    if options[:id] && !options[:id].to_s.empty?
      results << Tmdb.api_call('movie', {:id => options[:id].to_s}, options[:language])
    end

    if options[:title] && !options[:title].to_s.empty?
      data = {
        :query => options[:title].to_s,
        :search_type => options[:search_type].to_s
      }

      data[:year] = options[:year].to_s if options[:year]

      api_return = Tmdb.api_call('search/movie', data, options[:language])
      results << api_return['results'] if api_return
    end

    if options[:imdb] && !options[:imdb].to_s.empty?
      results << Tmdb.api_call('movie', {:id => options[:imdb].to_s}, options[:language])
      options[:expand_results] = true
    end
    
    results.flatten!(1)
    results.uniq!
    results.delete_if &:nil?
    
    if options[:limit]
      unless options[:limit].is_a?(Fixnum) && options[:limit] > 0
        raise ArgumentError, ':limit must be an integer greater than 0'
      end
      results = results.slice(0, options[:limit])
    end
    
    results.map!{|m| TmdbMovie.new(m, options[:expand_results], options[:language])}
    
    results.length == 1 ? results.first : results
  end
  
  def self.new(raw_data, expand_results = false, language = nil)
    # expand the result by calling movie unless :expand_results is false or the data is already complete
    # (as determined by checking for the posters property in the raw data)
    if expand_results && (!raw_data.has_key?('posters') || !raw_data['releases'] || !raw_data['cast'] || !raw_data['trailers'])
      begin
        movie_id              = raw_data['id']

        raw_data              = Tmdb.api_call('movie', { :id => movie_id }, language)
        @images_data          = Tmdb.api_call('movie/images', {:id => movie_id}, language)
        @releases_data        = Tmdb.api_call('movie/releases', {:id => movie_id}, language)
        @cast_data            = Tmdb.api_call('movie/casts', {:id => movie_id}, language)
        @trailers_data        = Tmdb.api_call('movie/trailers', {:id => movie_id}, language)

        raw_data['posters']   = @images_data['posters']
        raw_data['backdrops'] = @images_data['backdrops']
        raw_data['releases']  = @releases_data['countries']
        raw_data['cast']      = @cast_data['cast']
        raw_data['crew']      = @cast_data['crew']
        raw_data['trailers']  = @trailers_data['youtube']

      rescue => e
        if @images_data.nil? || @releases_data.nil? || @cast_data.nil? || @trailers_data.nil?
          raise ArgumentError, "Unable to fetch expanded infos for Movie ID: '#{movie_id}'"
        end
      end
    end
    return Tmdb.data_to_object(raw_data)
  end
  
  def ==(other)
    other.is_a?(TmdbMovie) ? @raw_data == other.raw_data : false
  end
    
end
