require "./spec_helper"

describe ART::RedirectResponse do
  describe "#status" do
    it "defaults to 302" do
      ART::RedirectResponse.new("addresss").status.should eq HTTP::Status::FOUND
    end

    it "disallows non redirect codes" do
      expect_raises(ArgumentError, "'422' is not an HTTP redirect status code.") do
        ART::RedirectResponse.new("addresss", 422)
      end
    end

    it Int do
      ART::RedirectResponse.new("addresss", 301).status.should eq HTTP::Status::MOVED_PERMANENTLY
    end

    it HTTP::Status do
      ART::RedirectResponse.new("addresss", HTTP::Status::MOVED_PERMANENTLY).status.should eq HTTP::Status::MOVED_PERMANENTLY
    end
  end

  describe "#headers" do
    it "with an empty url" do
      expect_raises(ArgumentError, "Cannot redirect to an empty URL.") do
        ART::RedirectResponse.new("")
      end
    end

    it "adds the location header" do
      ART::RedirectResponse.new("addresss").headers.should eq HTTP::Headers{"location" => "addresss"}
    end
  end
end
