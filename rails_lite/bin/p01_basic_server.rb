require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  res.set_cookie("cookie", {value:true})
  res.set_cookie("cookies", {value:true})
  res.write("#{req.cookies}, #{res.cookies}")
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)