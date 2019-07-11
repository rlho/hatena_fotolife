require 'net/http'
require 'oauth'

module HatenaFotolife
  module Requester
    ATOM_CONTENT_TYPE = 'application/x.atom+xml;'
    DEFAULT_HEADER = { 'Content-Type' => ATOM_CONTENT_TYPE }

    class RequestError < StandardError; end

    def self.create(config)
      consumer = ::OAuth::Consumer.new(config.consumer_key, config.consumer_secret)
      Requester::OAuth.new(::OAuth::AccessToken.new(consumer, config.access_token, config.access_token_secret))
    end

    class OAuth
      # Create a new OAuth 1.0a access token.
      # @param [OAuth::AccessToken] access_token access token object
      def initialize(access_token)
        @access_token = access_token
      end

      # HTTP GET method
      # @param [string] uri target URI
      # @return [Net::HTTPResponse] HTTP response
      def get(uri)
        request(:get, uri)
      end

      # HTTP POST method
      # @param [string] uri target URI
      # @param [string] body HTTP request body
      # @param [string] headers HTTP request headers
      # @return [Net::HTTPResponse] HTTP response
      def post(uri, body = '', headers = DEFAULT_HEADER)
        request(:post, uri, body: body, headers: headers)
      end

      # HTTP PUT method
      # @param [string] uri target URI
      # @param [string] body HTTP request body
      # @param [string] headers HTTP request headers
      # @return [Net::HTTPResponse] HTTP response
      def put(uri, body = '', headers = DEFAULT_HEADER)
        request(:put, uri, body: body, headers: headers)
      end

      # HTTP DELETE method
      # @param [string] uri target URI
      # @param [string] headers HTTP request headers
      # @return [Net::HTTPResponse] HTTP response
      def delete(uri, headers = DEFAULT_HEADER)
        request(:delete, uri, headers: headers)
      end

      private

      def request(method, uri, body: nil, headers: nil)
        @access_token.send(method, *[uri, body, headers].compact)
      rescue => problem
        raise RequestError, "Fail to #{method.upcase}: " + problem.to_s
      end
    end
  end
end
