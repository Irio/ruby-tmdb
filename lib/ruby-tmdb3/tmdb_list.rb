class TmdbList
  
  class NilData < StandardError; end;
  class CorruptData < StandardError; end;
  
  attr_accessor :page, :total_pages, :total_results, :movies_data, :movies
  
  class Movie
    
    ATTRIBUTES =[:backdrop_path, :id, :original_title, :release_date, :poster_path, :title, :vote_average, :vote_count]
    attr_accessor *ATTRIBUTES
    
    def initialize(data)
      begin
        ATTRIBUTES.each do |attr|
          instance_variable_set("@#{attr}", data[attr.to_s])
        end
      rescue
        raise "no data for movie"
      end
    end
    
  end
  
  def initialize(data)
    raise NilData if data.nil?
    begin
      self.movies_data = data
      self.page = data["page"]
      self.movies = data["results"].map{|r| TmdbList::Movie.new(r) rescue nil}.compact
      self.total_pages = data["total_pages"]
      self.total_results = data["total_results"]
    rescue Exception => e
      raise CorruptData, "Data wasn't in a structure we expected.\n #{e.message}\n #{e.backtrace}"
    end
  end
  
  def movie_ids
    self.movies.map(&:id)
  end
  
  
  def self.upcoming(page = 1, language = nil)
    data = Tmdb.api_call("movie/upcoming", {:page => page}, language)
    return TmdbList.new(data)
  end
  
  def self.now_playing(page = 1, language = nil)
    data = Tmdb.api_call("movie/now_playing", {:page => page}, language)
    return TmdbList.new(data)
  end
  
  def self.top_rated(page = 1, language = nil)
    data = Tmdb.api_call("movie/top_rated", {:page => page}, language)
    return TmdbList.new(data)
  end
  
  def self.popular(page = 1, language = nil)
    data = Tmdb.api_call("movie/popular", {:page => page}, language)
    return TmdbList.new(data)
  end
  
  def self.changes(new_options = {})
    options = {
      :page => 1,
      :start_date => Time.now.strftime("%Y-%m-%d"),
      :end_date => (Time.now+86400).strftime("%Y-%m-%d") #by default pull 1 days worth of changes
    }.merge(new_options)
    data = Tmdb.api_call('movie/changes', {
      :page => options[:page], 
      :start_date=> options[:start_date],
      :end_date=> options[:end_date]
    })
    return TmdbList.new(data)
  end
  
end