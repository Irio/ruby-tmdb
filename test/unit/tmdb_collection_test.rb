require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper.rb'))

class TmdbCollectionTest < Test::Unit::TestCase

  def setup
    register_api_url_stubs
  end
  
  test "find that returns no results should create empty array" do
    collection = TmdbCollection.find(:id => "item_not_found")
    assert_equal [], collection
  end
  
  test "collection should be able to be dumped and re-loaded" do
    assert_nothing_raised do
      collection = TmdbCollection.find(:id => 10)
      TmdbCollection.new(collection.raw_data)
    end
  end
  
  test "find by id should return the full collection data" do
    collection = TmdbCollection.find(:id => 10)
    assert_collection_methodized(collection, 10)
  end
  
  test "collections with same data should be seen as equal" do
    collection1 = TmdbCollection.find(:id => 10, :limit => 1)
    collection2 = TmdbCollection.find(:id => 10, :limit => 1)
    assert_equal collection1, collection2
  end
  
  test "should raise exception if no arguments supplied to find" do
    assert_raise ArgumentError do
      TmdbCollection.find()
    end
  end
  
  test "find by id should return a single collection" do
    assert_kind_of OpenStruct, TmdbCollection.find(:id => 10)
  end
  
  test "TmdbCollection.new should raise error if supplied with raw data for collection that doesn't exist" do
    Tmdb.expects(:api_call).with("collection", {:id => 999999999999}, nil).returns(nil)
    Tmdb.expects(:api_call).with("collection/images", {:id => 999999999999}, nil).returns(nil)
    assert_raise ArgumentError do
      TmdbCollection.new({"id" => 999999999999}, true)
    end
  end
  
  private
    
    def assert_collection_methodized(collection, collection_id)
      @collection_data = Tmdb.api_call("collection", {:id => collection_id.to_s}, Tmdb.default_language)
      assert_equal @collection_data["id"], collection.id
      assert_equal @collection_data["name"], collection.name
      assert_equal @collection_data["parts"][0]["id"], collection.parts[0].id
      assert_equal @collection_data["parts"][0]["title"], collection.parts[0].title
      assert_equal @collection_data["parts"][0]["release_date"], collection.parts[0].release_date
      assert_equal @collection_data["parts"][0]["poster_path"], collection.parts[0].poster_path
      assert_equal @collection_data["parts"][0]["backdrop_path"], collection.parts[0].backdrop_path
  
    end

end
