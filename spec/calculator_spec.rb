require_relative '../lib/calculator'

describe "calculator" do

  items = [ 
            {name: "chocolate bear", qty: 1, price: 0.85, good: false, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, 
            {name: "imported goldfish", qty: 1, price: 599.99, good: true, import: true, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99}, 
            {name: "bullfrog", qty: 1, price: 10.99, good: true, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 10.99} 
          ]

  results = [ 
              {name: "chocolate bear", qty: 1, price: 0.85, good: false, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, 
              {name: "imported goldfish", qty: 1, price: 599.99, good: true, import: true, good_tax: 60.0, import_tax: 30.0, sales_tax: 90.0, total: 689.99}, 
              {name: "bullfrog", qty: 1, price: 10.99, good: true, import: false, good_tax: 1.1, import_tax: 0.0, sales_tax: 1.1, total: 12.09} 
            ]

  purchases = Calculator.new(items)

  it "should calculate the item tax" do
    item_total = 1.00
    tax_rate = 0.05
    expect(purchases.compute_tax(item_total, tax_rate)).to eql(0.05)
  end

  it "should round the tax amount" do
    expect(purchases.round_tax(9.2543)).to eql(9.30)
  end

  it "should get the tax amount by calculating it and then rounding it" do
    item_total = 12.99
    tax_rate = 0.10
    expect(purchases.get_tax(item_total, tax_rate)).to eql(1.30)
  end

  it "should be able to check if an item is a good or a import and calculate and update the tax amount" do
    good_status = true
    base_total = 7.99
    tax_rate = 0.50
    expect(purchases.set_tax(good_status, base_total, tax_rate)).to eql(4.0)
  end

  it "should take the items and update the tax amounts" do
    expect(purchases.update_amounts).to eql(results)
  end

  it "should collect all the item sales_tax totals" do
    type = 'sales_tax'
    expect(purchases.capture_amounts(type)).to eql([0.0, 90.0, 1.1])
  end

  it "should collect all the item totals" do
    type = 'total'
    expect(purchases.capture_amounts(type)).to eql([0.85, 689.99, 12.09])
  end

  it "should calculate the total from the list of items" do
    list = [4, 3, 2, 0.2]
    expect(purchases.generate_total(list)).to eql(9.2)
  end

  it "should round the total after adding sales tax" do
    expect(purchases.add_taxes(18.99, 2.99, 0.0)).to eql(21.98)
  end

  it "should correctly set the totals for sales_tax and total_all" do
    purchases.set_totals
    expect(purchases.sales_tax).to eql(91.1)
    expect(purchases.total_all).to eql(702.93)
  end
end