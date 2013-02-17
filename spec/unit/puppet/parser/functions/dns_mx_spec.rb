#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dns_mx function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dns_mx").should == "function_dns_mx"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_dns_mx([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    lambda { scope.function_dns_mx(['one','two','three']) }.should( raise_error(Puppet::ParseError))
  end

  it "should not raise a ParseError if second argument is 'preference' or 'exchange'" do
    lambda { scope.function_dns_mx(['domain.tld','preference']) }.should_not( raise_error(Puppet::ParseError))
    lambda { scope.function_dns_mx(['domain.tld','exchange']) }.should_not( raise_error(Puppet::ParseError))
  end
end
