def register_api_url_stubs  
  unless(TEST_LIVE_API)
    
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "authentication_guest_session_new.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/authentication/guest_session/new" + ".*")).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_search.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/search/movie" + ".*")).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_search_year.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/search/movie" + ".*year=.*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_get_info.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_set_rating.txt")) do |file|
      stub_request(:post, Regexp.new(Tmdb.base_api_url + '/movie/\d+/rating' + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_list.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/upcoming" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_list.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/top_rated" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_list.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/popular" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_list.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/now_playing" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_changes.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/changes" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_posters.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + '/movie/\d+/images')).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_releases.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + '/movie/\d+/releases')).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_casts.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + '/movie/\d+/casts')).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_trailers.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + '/movie/\d+/trailers')).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "movie_imdb_lookup.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/movie/tt" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "person_get_info.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/person/" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "person_search.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/search/person" + ".*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "incorrect_api_url.txt")) do |file|
      stub_request(:get, Regexp.new(Tmdb.base_api_url + "/Movie.blarg/" + ".*")).to_return(file)
    end

    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "example_com.txt")) do |file|
      stub_request(:get, Regexp.new("http://example.com.*")).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "image.jpg")) do |file|
      stub_request(:get, Regexp.new('http://i[0-9].themoviedb.org/[backdrops|posters|profiles].*')).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "image.jpg")) do |file|
      stub_request(:get, Regexp.new('http://hwcdn.themoviedb.org/[backdrops|posters|profiles].*')).to_return(file)
    end
    
    File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "blank_result.txt")) do |file|
      stub_request(:get, Regexp.new("item_not_found$")).to_return(file)
    end
    
    stub_request(:get, 'http://thisisaurlthatdoesntexist.co.nz').to_return(:body => "", :status => 404, :headers => {'content-length' => 0})
  end
end
