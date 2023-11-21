# frozen_string_literal: true

require 'async/http/faraday'
require 'webmock/rspec'

RSpec.describe Async::Http::Bad::Request::Reproduction do
  let(:url) { 'https://example.com' }
  let(:body) { 'hello' }
  before { stub_request(:get, url).to_return(status: 200, body:) }

  shared_examples "a working http request" do
    it "does not throw a bad request error" do
      expect(connection.get(url).body).to eq body
    end
  end

  context "with the default Faraday adapter" do
    let(:connection) { Faraday.new }

    it_behaves_like "a working http request"
  end

  context "with the default Faraday adapter" do
    let(:connection) {  Faraday.new { |faraday| faraday.adapter :async_http } }

    it_behaves_like "a working http request"
  end
end
