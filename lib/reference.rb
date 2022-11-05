class Reference
  def initialize(ref)
    @ref = ref
  end

  def to_spec
    { :$ref => @ref }
  end
end
