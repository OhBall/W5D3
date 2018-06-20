require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, hash)
    @req = req
    @res = res
    @params = hash
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "cannot render twice" if already_built_response?
    res.status = 302
    res.set_header("location", url)
    @already_built_response = true
    @session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "cannot render twice" if already_built_response?

    res.set_header("content-type", content_type)
    
    res.write(content)

    @already_built_response = true
    @session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    class_name = self.class.to_s.underscore
    folder_name = "views/#{class_name}/#{template_name}.html.erb"
    dirname = File.dirname(__FILE__).split('/')[0...-1]
    
    full_folder_name = File.join(*dirname, folder_name)
    file_contents = File.read(full_folder_name)
    erb = ERB.new(file_contents).result(binding)
    
    render_content(erb, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
  end
end


class UsersController < ControllerBase
  
end
