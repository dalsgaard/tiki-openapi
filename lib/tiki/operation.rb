require_relative './props'
require_relative './parameter'
require_relative './response'
require_relative './reference'
require_relative './reason'
require_relative './request-body'

using Props

class Operation
  props :operation_id, :summary, :description, :deprecated, :tags
  scalar_props :operation_id, :summary, :description, :deprecated, :tags
  hash_props :responses
  array_props :parameters
  object_props :request_body

  def initialize(operation_id = nil)
    @operation_id = operation_id
    @responses = []
  end

  def external_documentation(url = nil, &block)
    @external_documentation = ExternalDocumentation.new url
    @external_documentation.instance_eval(&block) if block
  end

  def parameter(name = nil, ref: nil, **named, &block)
    @parameters ||= []
    if ref
      reference = Reference.new ref
      @parameters.push reference
    else
      parameter = Parameter.new name, **named
      parameter.instance_eval(&block) if block
      @parameters.push parameter
    end
  end

  def request_body(*args, ref: nil, **named, &block)
    if ref
      @request_body = Reference.new ref, :request_body
    else
      body = RequestBody.new(*args, **named)
      body.instance_eval(&block) if block
      @request_body = body
    end
  end

  def request_body!(*args, **named)
    request_body(*args, required: true, **named)
  end

  alias request_body? request_body
  alias body request_body
  alias body! request_body!
  alias body? request_body?

  def response(status = nil, schema = nil, description: nil, ref: nil, &block)
    if ref
      @responses.push [status || 200, Reference.new(ref, :response)]
    else
      unless status.is_a?(Integer) || schema
        schema = status
        status = 200
      end
      response = Response.new schema, description: description || reason(status)
      response.instance_eval(&block) if block
      @responses.push [status, response]
    end
  end

  def responses(*statuses)
    statuses.each { |status| response status }
  end

  def tags(*tags)
    @tags = tags.flatten
  end

  def to_spec
    props = {}
    scalar_props props
    array_props props
    hash_props props
    object_props props
    props
  end

  alias desc description
end
