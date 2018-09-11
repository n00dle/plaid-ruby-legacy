require 'plaid-hack/version'
require 'plaid-hack/errors'
require 'plaid-hack/connector'
require 'plaid-hack/category'
require 'plaid-hack/institution'
require 'plaid-hack/user'
require 'plaid-hack/transaction'
require 'plaid-hack/info'
require 'plaid-hack/income'
require 'plaid-hack/client'
require 'plaid-hack/webhook'

require 'uri'

# Public: The PlaidHack namespace.
module PlaidHack
  # Public: Available PlaidHack products.
  PRODUCTS = %i(connect auth info income risk).freeze

  class <<self
    # Public: The default Client.
    attr_accessor :client

    # Public: The Integer read timeout for requests to PlaidHack HTTP API.
    # Should be specified in seconds. Default value is 120 (2 minutes).
    attr_accessor :read_timeout

    # Public: A helper function to ease configuration.
    #
    # Yields self.
    #
    # Examples
    #
    #   PlaidHack.configure do |p|
    #     p.client_id = 'PlaidHack provided client ID here'
    #     p.secret = 'PlaidHack provided secret key here'
    #     p.env = :tartan
    #     p.read_timeout = 300   # it's 5 minutes, yay!
    #   end
    #
    # Returns nothing.
    def config
      client = Client.new
      yield client
      self.client = client
    end

    # Internal: Symbolize keys (and values) for a hash.
    #
    # hash   - The Hash with string keys (or nil).
    # values - The Boolean flag telling the function to symbolize values
    #          as well.
    #
    # Returns a Hash with keys.to_sym (or nil if hash is nil).
    def symbolize_hash(hash, values: false)
      return unless hash
      return hash.map { |h| symbolize_hash(h) } if hash.is_a?(Array)

      hash.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = values ? v.to_sym : v
      end
    end
  end
end
