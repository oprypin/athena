require "../spec_helper"

class TestController < ART::Controller
  @[ARTA::Get(path: "user/:id", constraints: {"id" => /\d+/})]
  def action1(id : Int64) : Int64
    id
  end
end

class OtherController < ART::Controller
  @[ARTA::Get(path: "user/:id", constraints: {"id" => /\d+/})]
  def action2(id : Int64) : Int64
    id
  end
end

ART.run
