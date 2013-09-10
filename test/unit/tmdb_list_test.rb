require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class TmdbListTest < Test::Unit::TestCase

  IDLIST = [49026,57387,84327,80041,62580,103332,84177,73567,55741,84334,85446,80035,89455,98066,84184,82650,112304,64635,84165,84169]

  def setup
    register_api_url_stubs
    Tmdb.rate_limit_time = 0
  end
  
  test "should return upcoming movies" do
    list = TmdbList.upcoming
    assert_kind_of Array, list.movie_ids
    assert_equal IDLIST, list.movie_ids
  end
  
  test "should return popular movies" do
    list = TmdbList.popular
    assert_kind_of Array, list.movie_ids
    assert_equal IDLIST, list.movie_ids
  end

  test "should return top_rate movies" do
    list = TmdbList.top_rated
    assert_kind_of Array, list.movie_ids
    assert_equal IDLIST, list.movie_ids
  end
  
  test "should return now_playing movies" do
    list = TmdbList.now_playing
    assert_kind_of Array, list.movie_ids
    assert_equal IDLIST, list.movie_ids
  end
  
  test "should return an array of Tmdb::Movie classes" do
    list = TmdbList.now_playing
    assert_kind_of Array, list.movies
    assert_kind_of TmdbList::Movie, list.movies[0]
    assert_equal "The Dark Knight Rises", list.movies[0].original_title
  end
  
  test "should return a list of movies that have changed" do
    list = TmdbList.changes({
      page: 1,
      start_date: "2012-03-25",
      end_date: "2012-03-26"
    })
    assert_kind_of Array, list.movie_ids
    assert_equal 77946, list.movie_ids.first
  end
  
  
  
end