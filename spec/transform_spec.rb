require_relative "../lib/transform"

describe "transform" do

  receipt = ["1, chocolate bar, 0.85", "1, nokia n95, 599.99", "1, nokia n95, 599.99"]
  exclusions = ["chocolate"]

  purchases = Transform.new(receipt, exclusions)

  cleaned_receipt = ["1, chocolate bar, 0.85", "1, nokia n95, 599.99"]
  phone = ["1", "nokia n95", "599.99"]
  phone_import = ["1", "imported nokia n9", "799.99"]
  chocolate = ["1", "chocolate bar", "0.85"]

  result_hash = [{ name: "chocolate bar", qty: 1, price: 0.85, good: false, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85 }]

  it "should cut up the input item strings array" do
    expect(purchases.cut(cleaned_receipt)).to eql([["1", "chocolate bar", "0.85"], ["1", "nokia n95", "599.99"]])
  end

  it "should detect the name:string" do
    expect(purchases.detect_name(phone)).to eql("nokia n95")
  end

  it "should detect the qty:integer" do
    expect(purchases.detect_qty(phone)).to eql(1)
  end

  it "should detect the price:float" do
    expect(purchases.detect_price(phone)).to eql(599.99)
  end

  it "should classify if the item is a good:boolean" do
    expect(purchases.classify_good(phone)).to eql(true)
    expect(purchases.classify_good(chocolate)).to eql(false)
  end

  it "should classify if the item is a import:boolean" do
    expect(purchases.classify_import(phone)).to eql(false)
    expect(purchases.classify_import(phone_import)).to eql(true)
  end

  it "should return 0.0 for value" do
    expect(purchases.value).to eql(0.0)
  end

  it "should add good_tax:float and import_tax:float together" do
    expect(purchases.sales_tax(2.0, 0.30)).to eql(2.30)
  end

  it "should find the total of qty * price + sales_tax" do
    expect(purchases.calculate_total(phone, 0.0)).to eql(599.99)
  end
  
  it "should detect the items and build a hash made up of item name:string, qty:integer, price:float, good:boolean, import:boolean, total:float" do
    expect(purchases.detect(chocolate)).to eql(result_hash[0])
  end

  it "should update the list of items" do
    list = []
    purchases.update_items(chocolate, list)
    expect(list).to eql(result_hash)
  end

  it "should set qty to 0 if there is no integer" do
    zero_qty_item = ["zero, nothing here, 9.99", "1, nokia n95, 599.99"]
    expect(purchases.parser(zero_qty_item)).to eql([ { name: "nothing here", qty: 0, price: 9.99, good: true, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 }, {:name=>"nokia n95", :qty=>1, :price=>599.99, :good=>true, :import=>false, :good_tax=>0.0, :import_tax=>0.0, :sales_tax=>0.0, :total=>599.99} ])
  end

  it "should set price to 0 if there is no float" do
    no_price = ["1, nothing here, zero"]
    expect(purchases.parser(no_price)).to eql([ { name: "nothing here", qty: 1, price: 0.0, good: true, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 } ])
  end

  it "should select items with a qty > 0" do
    no_qty = [ { name: "nothing here", qty: 0, price: 9.99, good: true, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.0 }, {:name=>"nokia n95", :qty=>1, :price=>599.99, :good=>true, :import=>false, :good_tax=>0.0, :import_tax=>0.0, :sales_tax=>0.0, :total=>599.99} ]
    expect(purchases.clean(no_qty)).to eql([{:name=>"nokia n95", :qty=>1, :price=>599.99, :good=>true, :import=>false, :good_tax=>0.0, :import_tax=>0.0, :sales_tax=>0.0, :total=>599.99}])
  end

  it "should take the receipt, and exclusions and be able to generate a finalized output of items with a qty > 0" do
    receipt = ["1, chocolate bear, 0.85", "1, imported goldfish, 599.99", "1, bullfrog, 10.99", "there, is nothing, here", "zeros here, 9.99"]
    exclusions = ["chocolate"]
    purchases = Transform.new(receipt, exclusions)
    expect(purchases.generate).to eql([ {name: "chocolate bear", qty: 1, price: 0.85, good: false, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, {name: "imported goldfish", qty: 1, price: 599.99, good: true, import: true, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99}, {name: "bullfrog", qty: 1, price: 10.99, good: true, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 10.99} ])
  end

end