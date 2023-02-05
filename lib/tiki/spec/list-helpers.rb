module ListHelpers
  refine Symbol do
    def |(other)
      OrList.new self, other
    end

    def &(other)
      AndList.new self, other
    end

    def <(other)
      LessList.new self, other
    end
  end

  refine String do
    def |(other)
      OrList.new self, other
    end

    def &(other)
      AndList.new self, other
    end
  end

  refine Array do
    def |(other)
      OrList.new self, other
    end

    def &(other)
      AndList.new self, other
    end
  end
end

class OrList
  attr_reader :list

  def initialize(*args)
    @list = args
  end

  def |(other)
    @list << other
    self
  end
end

class AndList
  attr_reader :list

  def initialize(*args)
    @list = args
  end

  def &(other)
    @list << other
    self
  end
end

class LessList
  attr_reader :list

  def initialize(*args)
    @list = args
  end
end
