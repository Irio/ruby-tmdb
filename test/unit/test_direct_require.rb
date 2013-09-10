require 'test/unit'
require 'mocha/setup'

require_files = []
require_files << File.join(File.dirname(__FILE__), "..", "..", "lib", "ruby-tmdb3.rb")
require_files.concat Dir[File.join(File.dirname(__FILE__), '..', 'setup', '*.rb')]

require_files.each do |file|
  require File.expand_path(file)
end

class DirectRequireTest < Test::Unit::TestCase
  
  def setup

    Tmdb.rate_limit_time = 0
  end
  
  test "TmdbMovie should not raise exception when directly required without using rubygems" do
    Tmdb.stubs(:api_call).returns([])
    assert_nothing_raised do
      TmdbMovie.find(:id => 187)
    end
  end

  test "TmdbCast should not raise exception when directly required without using rubygems" do
    Tmdb.stubs(:api_call).returns([])
    assert_nothing_raised do
      TmdbCast.find(:id => 287)
    end
  end

end
