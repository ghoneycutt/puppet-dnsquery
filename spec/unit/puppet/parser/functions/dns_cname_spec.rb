#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dns_cname function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dns_cname").should == "function_dns_cname"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_dns_cname([]) }.should( raise_error(Puppet::ParseError))
  end

  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:dns_cname)
    scope.method(function_name)
  end

  before :each do
    scope.stubs(:lookupvar).with('www.he.net').returns('he.net')
  end

  it 'should return a string with one CNAME record (he.net)' do
    subject.call(['www.he.net']).should be_true
    subject.call(['www.he.net']).class.should == String
  end

  it 'should raise an error if there is no CNAME record' do
    lambda { scope.function_dns_cname(['no_cname.example.tld']) }.should( raise_error(Resolv::ResolvError))
  end
end
