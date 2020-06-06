# A container for storing key/value pairs.  Can be used to store arbitrary data within the context of a request.
struct Athena::Routing::ParameterBag
  private abstract struct Param
    abstract def value
  end

  private record Parameter(T) < Param, value : T

  @parameters : Hash(String, Param) = Hash(String, Param).new

  # Returns `true` if a parameter with the provided *name* exists, otherwise `false`.
  def has?(name : String) : Bool
    @parameters.has_key? name
  end

  # Returns the value of the parameter with the provided *name* if it exists, otherwise `nil`.
  def get?(name : String)
    @parameters[name]?.try &.value
  end

  # Returns the value of the parameter with the provided *name*.
  #
  # Raises a `KeyError` if no parameter with that name exists.
  def get(name : String)
    get?(name) || raise KeyError.new "No parameter exists with the name '#{name}'."
  end

  {% for type in [Bool, String] + Number::Primitive.union_types %}
    # Returns the value of the parameter with the provided *name* as a `{{type}}`.
    def get(name : String, _type : {{type}}.class) : {{type}}
      {{type}}.from_parameter(get(name)).as {{type}}
    end
  {% end %}

  # Sets a parameter with the provided *name* to *value*.
  def set(name : String, value : _) : Nil
    @parameters[name] = Parameter.new value
  end

  # Sets a parameter with the provided *name* to *value*, restricted to the given *type*.
  def set(name : String, value : _, type : T.class) : Nil forall T
    @parameters[name] = Parameter(T).new value
  end

  # Removes the parameter with the provided *name*.
  def remove(name : String) : Nil
    @parameters.delete name
  end
end