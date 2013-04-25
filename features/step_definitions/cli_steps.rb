When /^there are no arguments$/ do
  @output = `pinup`
end

Then /^it should print the help text$/ do
  expect(@output).to match(/SYNOPSIS/)
  expect(@output).to match(/VERSION/)
  expect(@output).to match(/--help/)
  @output = nil
end

When /^help is passed as an argument$/ do
  @output = `pinup help`
end

When /^the user passes an invalid command$/ do
  `pinup foobar`
end

Then /^it should have the correct exit status$/ do
  expect($?.exitstatus).to equal(64)
end
