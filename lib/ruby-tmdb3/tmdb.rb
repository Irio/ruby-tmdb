class Tmdb
  
  require 'net/http'
  require 'uri'
  require 'cgi'
  require 'json'
  require 'deepopenstruct'
  require "addressable/uri"
  
  @@api_key = ""
  @@default_language = "en"
  @@api_response = {}
  @@last_request_at = Time.now-3600
  @@rate_limit_time = 0.34
  @@base_api_url = "http://api.themoviedb.org/3"

  # TODO: Should be refreshed and cached from API 
  CONFIGURATION = DeepOpenStruct.load({ "images" =>
                    { 
                      "base_url"        => "http://cf2.imgobject.com/t/p/", 
                      "posters_sizes"   => ["w92", "w154", "w185", "w342", "w500", "original"],
                      "backdrops_sizes" => ["w300", "w780", "w1280", "original"],
                      "profiles_sizes"  => ["w45", "w185", "h632", "original"],
                      "logos_sizes"     => ["w45", "w92", "w154", "w185", "w300", "w500", "original"]
                    }
  })
  
  def self.api_key
    @@api_key
  end
  
  def self.api_key=(key)
    @@api_key = key
  end
  
  def self.rate_limit_time
    @@rate_limit_time
  end
  
  def self.rate_limit_time=(time)
    @@rate_limit_time = time
  end
  
  def self.default_language
    @@default_language
  end
  
  def self.default_language=(language)
    @@default_language = language
  end
  
  def self.base_api_url
    @@base_api_url
  end
  
  
  def self.base_api_url=(url)
    @@base_api_url=url
  end
  
  def self.api_call(method, data, language = nil, post = false)
    raise ArgumentError, "Tmdb.api_key must be set before using the API" if(Tmdb.api_key.nil? || Tmdb.api_key.empty?)
    raise ArgumentError, "Invalid data." if(data.nil? || (data.class != Hash))
    
    action = method.match(%r{.*/(.*)})[1] rescue nil
    method = method.sub(%r{/[^/]*?$}, '')
    
    data = {
      :api_key =>  Tmdb.api_key
    }.merge(data)

    data.merge!(:language => language) if language

    # Addressable can only handle hashes whose values respond to to_str, so lets be nice and convert things.
    query_values = {}
    data.each do |key,value|
      if not value.respond_to?(:to_str) and value.respond_to?(:to_s)
        query_values[key] = value.to_s
      else
        query_values[key] = value
      end
    end

    uri = Addressable::URI.new

    # Construct URL for queries with id
    if data.has_key?(:id)
      uri.query_values = query_values
    # Construct URL other queries
    elsif data.has_key?(:query)
      query_values = {
        :query => CGI::escape(data[:query])
      }.merge(query_values)
      uri.query_values = query_values
    else
      #do nothing? had to add this to allow for upcoming movie searches
      uri.query_values = query_values
    end
    
    url            = [Tmdb.base_api_url, method, data[:id], action].compact.join '/'
    url_with_query = [url, uri.query].compact.join '?'
    
    response = Tmdb.get_url(url_with_query) unless post
    response = Tmdb.post_url(url_with_query, query_values) if post
    
    if(response.code.to_i != 200 && response.code.to_i != 201)
      raise RuntimeError, "Tmdb API returned status code '#{response.code}' for URL: '#{url_with_query}'"
    end

    body = JSON(response.body)
    if body.has_key?("results") && body["results"].empty?
      return nil
    else
      return body
    end
  end

  # Get a URL and return a response object, follow upto 'limit' re-directs on the way
  def self.post_url(uri_str, query_values, limit = 10)
    if Time.now < @@last_request_at+@@rate_limit_time #this will help avoid rate limit issues
      sleep @@last_request_at+@@rate_limit_time-Time.now if @@rate_limit_time > 0
    end
    @@last_request_at = Time.now
    return false if limit == 0
    begin 
      uri = URI(uri_str)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_content_type("application/json")
      response = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(request, query_values.to_json)
      }
    rescue SocketError, Errno::ENETDOWN
      response = Net::HTTPBadRequest.new( '404', 404, "Not Found" )
      return response
    end
    response
  end
  
  def self.get_url(uri_str, limit = 10)
    
    if Time.now < @@last_request_at+@@rate_limit_time #this will help avoid rate limit issues
      sleep @@last_request_at+@@rate_limit_time-Time.now if @@rate_limit_time > 0
    end
    @@last_request_at = Time.now
    return false if limit == 0
    begin 
      response = Net::HTTP.get_response(URI.parse(uri_str))
    rescue SocketError, Errno::ENETDOWN
      response = Net::HTTPBadRequest.new( '404', 404, "Not Found" )
      return response
    end 
    case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then get_url(response['location'], limit - 1)
    else
      Net::HTTPBadRequest.new( '404', 404, "Not Found" )
    end
  end
  
  def self.data_to_object(data)
    object          = DeepOpenStruct.load(data)
    object.raw_data = data
    ["posters", "backdrops"].each do |image_array_name|
      image_array = Array object.send(image_array_name)
      single_name = image_array_name.slice 0..-2 # singularize name
      single_path = object.send "#{single_name}_path" # default poster/backdrop image
      image_array << object.send("#{image_array_name.slice 0..-2}=", DeepOpenStruct.load({:file_path => single_path}))
      # build a struct containing availables sizes with their urls
      image_array.each do |image|
        urls = CONFIGURATION.images.send("#{image_array_name}_sizes").inject({}) do |hash, size|
          hash[size] = {'url' => [CONFIGURATION.images.base_url, size, image.file_path].join}
          hash
        end
        image.sizes = DeepOpenStruct.load urls
      end
    end
    unless(object.cast.nil?)
      object.cast.each_index do |x|
        object.cast[x].instance_eval <<-EOD
          def self.bio
            return TmdbCast.find(:id => self.id, :limit => 1)
          end
        EOD
      end
    end
    return object
  end
  
end
