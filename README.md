### How to Run
`ruby generate.rb <filename>.txt`  
*Note*: The text file must be placed in the `input` folder. 3 files from the problem have been included for your convenience.  
#### Input Files:
- input1.txt
- input2.txt
- input3.txt
  
***
### Testing
Tests were done with `rspec`.  
`rspec spec/<filename>.rb` - individual test  
`rspec` - run all tests  
#### Test Files:
- input_spec.rb - tests for file input
- transform_spec.rb - tests for file input being parsed correctly
- calculator_spec.rb - tests for calculating sales tax and totals
- printer_spec.rb - tests for printing the output
- run_tax.rb - tests that the 3 input files output correctly
