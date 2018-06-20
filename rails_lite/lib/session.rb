require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookie_hash = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @cookie_hash = {}
    end
    
    @cookie_hash[:session] = {} unless @cookie_hash[:session]
  end
  
  def session_hash
    @cookie_hash[:session]
  end

  def [](key)
    session_hash[key]
  end

  def []=(key, val)
    session_hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie("_rails_lite_app", @cookie_hash.to_json)
  end
end
