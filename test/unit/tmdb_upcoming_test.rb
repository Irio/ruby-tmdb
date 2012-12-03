require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class TmdbMovieTest < Test::Unit::TestCase

  def setup
    register_api_url_stubs
  end
  
  test "should return upcoming movies" do
    upcoming = TmdbUpcoming.find
    assert_kind_of Array, upcoming.movie_ids
    assert_equal [49026,57387,84327,80041,62580,103332,84177,73567,55741,84334,85446,80035,89455,98066,84184,82650,112304,64635,84165,84169], upcoming.movie_ids
  end
  
end