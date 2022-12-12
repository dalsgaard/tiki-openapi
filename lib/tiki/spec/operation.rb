require_relative './props'
require_relative './parameter'
require_relative './response'
require_relative './reference'
require_relative './reason'
require_relative './request-body'
require_relative './external-documentation'

using Props

class Operation
  props :operation_id, :summary, %i[description desc], :deprecated
  named_props :tags
  scalar_props :operation_id, :summary, :description, :deprecated, :tags, :security
  hash_props :responses
  array_props :parameters
  object_props :request_body, :external_docs

  def initialize(operation_id = nil, **named)
    @operation_id = operation_id
    named_props named
    @responses = []
  end

  def tags(*tags)
    @tags ||= []
    @tags += tags.flatten
  end

  def external_docs(*args, **named, &block)
    @external_docs = ExternalDocumentation.new(*args, **named)
    @external_docs.instance_eval(&block) if block
  end

  alias docs external_docs

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

  def parameter!(*args, **named)
    parameter(*args, required: true, **named)
  end

  def parameter?(*args, **named)
    parameter(*args, required: false, **named)
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

  def response(status = nil, schema = nil, description: nil, desc: nil, mime: nil, ref: nil, &block)
    if ref
      @responses.push [status || 200, Reference.new(ref, :response)]
    else
      unless status.is_a?(Integer) || status == :default || schema
        schema = status
        status = 200
      end
      response = Response.new schema, mime, description: description || desc || reason(status)
      response.instance_eval(&block) if block
      @responses.push [status, response]
    end
  end

  def responses(*statuses)
    statuses.each { |status| response status }
  end

  def security(_type = nil, **named)
    @security ||= []
    @security << named
  end

  def to_spec
    props = {}
    scalar_props props
    array_props props
    hash_props props
    object_props props
    props
  end

  def check_parameter(name)
    @parameters&.find { |p| p.get_name == name }
  end
end
