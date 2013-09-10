require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class FetchTrailersWithExpansionEnabled < Test::Unit::TestCase
  def setup
    register_api_url_stubs
    Tmdb.rate_limit_time = 0
  end

  test "find with expansion enabled should return trailers" do
    movie = TmdbMovie.find(:id => 187)
    assert_not_nil movie.trailers
    assert_equal movie.trailers[0].source, 'SUXWAEX2jlg'
  end

  test "find without expansion enabled should not return trailers" do
    movie = TmdbMovie.find :id => 187, :expand_results => false
    assert_nil movie.trailers
  end
end
