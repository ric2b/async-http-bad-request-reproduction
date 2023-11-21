# frozen_string_literal: true

require 'async/http/internet'
require 'async/http/faraday'
require 'webmock/rspec'

RSpec.describe Async::Http::Bad::Request::Reproduction do
  let(:url) { 'https://example.com' }
  let(:body) { 'hello' }

  context "with webmock" do
    before { stub_request(:get, url).to_return(status: 200, body:) }

    context "with the default Faraday adapter" do
      let(:connection) { Faraday.new }

      it "does not throw a bad request error" do
        expect(connection.get(url).body).to eq body
      end
    end

    context "with the async-http Faraday adapter" do
      let(:connection) {  Faraday.new { |faraday| faraday.adapter :async_http } }

      it "does not throw a bad request error" do
        expect(connection.get(url).body).to eq body
      end
    end
  end

  context "without webmock" do
    before { WebMock.disable! }

    context "with the default Faraday adapter" do
      let(:connection) { Faraday.new }

      it "does not throw a bad request error" do
        expect(connection.get(url).status).to eq 200
      end
    end

    context "with the async-http Faraday adapter" do
      let(:connection) {  Faraday.new { |faraday| faraday.adapter :async_http } }

      it "does not throw a bad request error" do
        expect(connection.get(url).body).to eq 200
      end
    end
  end

  context "without faraday" do
    let(:connection) { Async::HTTP::Internet.new }

    context "with webmock" do
      before { stub_request(:get, url).to_return(status: 200, body:) }

      it "does not throw a bad request error" do
        Sync do
          expect(connection.get(url).body).to eq body
        end
      end
    end

    context "without webmock" do
      before { WebMock.disable! }

      it "does not throw a bad request error" do
        Sync do
          expect(connection.get(url).status).to eq 200
        end
      end
    end
  end
end
