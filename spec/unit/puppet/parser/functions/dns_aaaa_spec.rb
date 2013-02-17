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
    scope.stubs(:lookupvar).with('multiple_quad_a.exmaple.tld').returns(['2001:410:0:76::2','2001:410:0:76::3'])
  end

  it 'should return a string with one AAAA record (2001:470:0:76::2)' do
    subject.call(['he.net']).should be_true
    subject.call(['he.net']).class.should == String
  end

  it 'should return an array with multiple AAAA records ([2001:410:0:76::2,2001:410:0:76::3])' do
    subject.call(['multiple_quad_a.exmaple.tld']).should be_true
    subject.call(['multiple_quad_a.exmaple.tld']).class.should == Array
  end

  it 'should raise an error if there is no AAAA record' do
    lambda { scope.function_dns_cname(['no_aaaa.example.tld']) }.should( raise_error(Resolv::ResolvError))
  end
end
