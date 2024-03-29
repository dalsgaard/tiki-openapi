module Props
  refine Class do
    def props(*names)
      names.flatten.each do |name|
        if name.is_a? Array
          n = name.first
          define_method n do |value|
            instance_variable_set("@#{n}", value)
          end
          name[1..].each do |a|
            alias_method a, n
          end
        else
          define_method name do |value|
            instance_variable_set("@#{name}", value)
          end
        end
      end
    end

    def marker_props(*names)
      names.flatten.each do |name|
        define_method name do |value = true|
          instance_variable_set("@#{name}", value)
        end
      end
    end

    def named_props(*names)
      var_names = {}
      names.each do |name|
        if name.is_a? Array
          v = "@#{name.first}"
          name.each { |n| var_names[n] = v }
        else
          var_names[name] = "@#{name}"
        end
      end
      define_method :named_props do |named|
        names = names.flatten
        named.each_pair do |name, value|
          var_name = var_names[name]
          if var_name && !value.nil?
            instance_variable_set var_name, value
          else
            puts "Unknown named argument #{name}"
          end
        end
      end
    end

    def scalar_props(*names)
      define_method :scalar_props do |props = {}|
        names.flatten.each do |name|
          value = instance_variable_get "@#{name}"
          props[to_camel(name).to_sym] = value unless value.nil?
        end
        props
      end
    end

    def object_props(*names)
      define_method :object_props do |props = {}|
        names.flatten.each do |name|
          value = instance_variable_get "@#{name}"
          props[to_camel(name).to_sym] = value.to_spec unless value.nil?
        end
        props
      end
    end

    def object_or_scalar_props(*names)
      define_method :object_or_scalar_props do |props = {}|
        names.flatten.each do |name|
          value = instance_variable_get "@#{name}"
          unless value.nil?
            value = value.to_spec if value.respond_to? :to_spec
            props[to_camel(name).to_sym] = value
          end
        end
        props
      end
    end

    def hash_props(*names)
      define_method :hash_props do |props = {}|
        names.flatten.each do |name|
          hashes = instance_variable_get "@#{name}"
          unless hashes.nil?
            value = hashes.map(&->((n, s)) { { n => s.to_spec } }).inject(&:merge) || {}
            props[to_camel(name).to_sym] = value
          end
        end
        props
      end
    end

    def array_props(*names)
      define_method :array_props do |props = {}|
        names.flatten.each do |name|
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
