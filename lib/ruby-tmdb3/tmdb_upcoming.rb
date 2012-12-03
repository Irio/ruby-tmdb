class TmdbUpcoming
  
  class Nildata < StandardError; end;
  class CorruptData < StandardError; end;
  
  attr_accessor :page, :movie_ids, :total_pages, :total_results, :movies_data
  
  def initialize(data)
    raise Nildata if data.nil?
    begin
      self.movies_data = data
      self.page = data["page"]
      self.movie_ids = data["results"].map{|r| r["id"]}
      self.total_pages = data["total_pages"]
      self.total_results = data["total_results"]
    rescue Exception => e
      raise CorruptData, "Upcoming data wasn't in a structure we expected."
    end
  end
  
  def self.find(page = 1, language = nil)
    data = Tmdb.api_call("movie/upcoming", {page: page}, language)
    return TmdbUpcoming.new(data)
  end
  
  def next_page

    data = Tmdb.api_call("movie/upcoming", {page: self.page+1}, language)
    return TmdbUpcoming.new(data)
  end

end