module Props
  refine Class do
    def props(*names)
      names.each do |name|
        define_method name do |value|
          instance_variable_set("@#{name}", value)
        end
      end
    end

    def named_props(*names)
      define_method :named_props do |named|
        names.each do |name|
          val = named[name]
          instance_variable_set "@#{name}", val unless val.nil?
        end
      end
    end

    def scalar_props(*names)
      define_method :scalar_props do |props = {}|
        names.each do |name|
          value = instance_variable_get "@#{name}"
          props[to_camel(name).to_sym] = value unless value.nil?
        end
        props
      end
    end

    def object_props(*names)
      define_method :object_props do |props = {}|
        names.each do |name|
          value = instance_variable_get "@#{name}"
          props[to_camel(name).to_sym] = value.to_spec unless value.nil?
        end
        props
      end
    end

    def hash_props(*names)
      define_method :hash_props do |props = {}|
        names.each do |name|
          hashes = instance_variable_get "@#{name}"
          if !hashes.nil? && !hashes.empty?
            value = hashes.map(&->((n, s)) { Hash[n, s.to_spec] }).inject(&:merge)
            props[to_camel(name).to_sym] = value
          end
        end
        props
      end
    end

    def array_props(*names)
      define_method :array_props do |props = {}|
        names.each do |name|
          array = instance_variable_get "@#{name}"
          props[to_camel(name).to_sym] = array.map(&:to_spec) unless array.nil?
        end
        props
      end
    end
  end
end

def to_camel(snake)
  snake.to_s.gsub(/_([a-z])/) { Regexp.last_match(1).upcase }
end

def to_snake(camel)
  camel.to_s.gsub(/([A-Z])/) { "_#{Regexp.last_match(1).downcase}" }
end
