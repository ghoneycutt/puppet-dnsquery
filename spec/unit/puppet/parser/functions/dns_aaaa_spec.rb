#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dns_aaaa function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dns_aaaa").should == "function_dns_aaaa"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_dns_aaaa([]) }.should( raise_error(Puppet::ParseError))
  end

  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:dns_aaaa)
    scope.method(function_name)
  end

  before :each do
    scope.stubs(:lookupvar).with('he.net').returns(['2001:470:0:76::2'])
  end

  it 'should return an array with one AAAA record (2001:470:0:76::2)' do
    subject.call(['he.net']).should be_true
  end

  it 'should raise and error if there is no AAAA record' do
    lambda { scope.function_dns_cname(['no_aaaa.example.tld']) }.should( raise_error(Resolv::ResolvError))
  end
end
