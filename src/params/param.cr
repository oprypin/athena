require "./param_interface"

# Base implementation of `ART::Params::ParamInterface`.
abstract struct Athena::Routing::Params::Param
  # :inherit:
  getter name : String

  # :inherit:
  getter description : String?

  # :inherit:
  getter incompatibles : Array(String)?

  # :inherit:
  getter? strict : Bool = true

  # If this argument has a default value.
  getter? has_default : Bool

  # If `nil` is a valid value for the param.
  getter? nilable : Bool

  def initialize(
    @name : String,
    @has_default : Bool = false,
    @incompatibles : Array(String)? = nil,
    @strict : Bool = true,
    @nilable : Bool = false,
    @key : String? = nil,
    @description : String? = nil
  )
  end

  # :inherit:
  def constraints : Array(AVD::Constraint)
    constraints = [] of AVD::Constraint

    unless self.nilable?
      constraints << AVD::Constraints::NotNil.new
    end

    constraints
  end

  # Returns the key that should be used to access `self` from a given request.
  #
  # Defaults to `#name`, but may be customized.  See [ARTA::QueryParam@key](../QueryParam.html#key).
  def key : String
    @key || @name
  end
end
