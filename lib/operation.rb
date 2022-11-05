require_relative './props'
require_relative './parameter'
require_relative './response'
require_relative './reference'
require_relative './reason'

using Props

class Operation
  props :operation_id, :summary, :description, :deprecated, :tags
  scalar_props :operation_id, :summary, :description, :deprecated, :tags
  hash_props :responses
  array_props :parameters

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

  def body(&block); end

  def response(status = nil, description = nil, schema: nil, ref: nil, &block)
    if ref
      @responses.push [status || 200, Reference.new(ref)]
    else
      if status.is_a? Integer
        s = status
        desc = description || reason(status)
      elsif status.is_a?(String) && description.nil?
        s = 200
        desc = status
      elsif status.nil?
        s = 200
        desc = nil
      else
        s = status
        desc = description
      end
      response = Response.new desc, schema
      response.instance_eval(&block) if block
      @responses.push [s, response]
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
    props
  end
end
