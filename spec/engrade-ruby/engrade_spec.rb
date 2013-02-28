require_relative '../spec_helper'

describe Engrade do
  it "must work" do
    e = Engrade.new
    "Yay!".must_be_instance_of String
  end
end
