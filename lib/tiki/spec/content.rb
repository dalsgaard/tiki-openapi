require_relative './media-type'

module Content
  def content(mime = nil, *args, **named, &block)
    @content ||= []
    media_type = MediaType.new(*args, **named)
    media_type.instance_eval(&block) if block
    @content.push [resolve_mime_type(mime), media_type]
    media_type
  end

  def schema(type = nil, title = nil, example: nil, **named, &block)
    if @default_content
      @default_content.schema type, title, **named, &block
      @default_content.example example if example
    else
      @default_content = content example: example do
        schema type, title, **named, &block
      end
    end
  end

  def object(title, **named, &block)
    schema :object, title, **named, &block
  end

  def array(items_type = nil, title = nil, **named, &block)
    schema :array, title do
      items items_type, **named, &block
    end
  end
end

MIME_TYPES = {
  json: 'application/json',
  xml: 'application/xml',
  html: 'text/html',
  form: 'application/x-www-form-urlencoded',
  form_data: 'multipart/form-data',
  all: '*/*'
}.freeze

def resolve_mime_type(mime)
  MIME_TYPES[mime] || mime || 'application/json'
end
