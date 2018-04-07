require_relative "../lib/input"

describe "input" do 

  purchases = Input.new("input1.txt")

  it "should take the input file and turn it into an array" do
    expect(purchases.items.class).to eql(Array)
  end

  it "should take the exclusions file and turn it into an array" do
    expect(purchases.exclusions.class).to eql(Array)
  end

end