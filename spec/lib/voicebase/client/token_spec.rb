require 'spec_helper'
require 'timecop'

describe Voicebase::Client::Token do
  context "#expired?" do
    let(:timeout) { 10 }
    let(:initial_time) { Time.local(2016, 5, 2, 16, 22, 0) }
    let(:non_expired_time) { Time.local(2016, 5, 2, 16, 22, timeout-1) }
    let(:expired_time) { Time.local(2016, 5, 2, 16, 22, timeout+1) }
    let(:some_token) { 'token' }

    before do
      Timecop.freeze(initial_time)
    end

    it "is false when the timeout period has not expired" do
      token = Voicebase::Client::Token.new(some_token, timeout)
      Timecop.travel(non_expired_time)
      expect(token.expired?).to be_truthy
    end

    it "is true when the timeout period has expired" do
      token = Voicebase::Client::Token.new(some_token, timeout)
      Timecop.travel(expired_time)
      expect(token.expired?).to be_truthy
    end

    it "delegates token method to_s" do
      expect(Voicebase::Client::Token.new("foobar").to_s).to eq("foobar")
    end

    it "is not expired when infinity" do
      token = Voicebase::Client::Token.new("foobar")
      expect(token.timeout).to eq(Float::INFINITY)
      expect(token).not_to be_expired
    end
  end
end
