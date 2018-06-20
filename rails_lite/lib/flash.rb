require 'json'
  
class Flash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookie_hash = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @cookie_hash = {}
    end
    
    @cookie_hash[:flash] = {} unless @cookie_hash[:flash]
  end
  
  def flash_hash
    @cookie_hash[:flash]
  end
  
  
end
