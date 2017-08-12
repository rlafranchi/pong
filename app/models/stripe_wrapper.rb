module StripeWrapper
  class Charge
    attr_reader :response, :error_message
    def initialize(response, error_message)
      @response = response
      @error_message = error_message
    end
    def self.create(customer_id)
      begin
        response = Stripe::Charge.create(
          amount: 100,
          currency: "usd",
          description: "A single game of Pong",
          customer: customer_id
        )
        new(response, nil)
      rescue Stripe::CardError => e
        new(nil, e.message)
      end
    end
    def successful?
      @response.present?
    end
    def error_message
      @error_message
    end
  end
  class Customer
    attr_reader :response, :error_message
    def initialize(response, error_message)
      @response = response
      @error_message = error_message
    end
    def self.create(token_id)
      begin
        token = Stripe::Token.retrieve(token_id)
        response = Stripe::Customer.create(
          source: token_id,
          email: token.email
        )
        new(response, nil)
      rescue Stripe::CardError => e
        new(nil, e.message)
      end
    end
    def successful?
      @response.present?
    end
    def error_message
      @error_message
    end
  end
end
