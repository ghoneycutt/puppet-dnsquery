#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dns_a function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dns_a").should == "function_dns_a"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_dns_a([]) }.should( raise_error(Puppet::ParseError))
  end

  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:dns_a)
    scope.method(function_name)
  end

  before :each do
    scope.stubs(:lookupvar).with('a.resolvers.Level3.net').returns(['4.2.2.1'])
    scope.stubs(:lookupvar).with('google.com').returns(['173.194.44.48',
                                                       '173.194.44.49',
                                                       '173.194.44.50',
                                                       '173.194.44.51',
                                                       '173.194.44.52'])
  end

  it 'should return an array with one A record (4.2.2.1)' do
    subject.call(['a.resolvers.Level3.net']).should be_true
  end

  it 'should return an array with multiple A records ([173.194.44.48,173.194.44.49,173.194.44.50,173.194.44.51,173.194.44.52])' do
    subject.call(['google.com']).should be_true
  end

  it 'should raise and error if there is no A record' do
    lambda { scope.function_dns_cname(['no_a.example.tld']) }.should( raise_error(Resolv::ResolvError))
  end
end
