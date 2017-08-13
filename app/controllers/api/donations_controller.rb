module Api
  class DonationsController < ApplicationController
    def create
      charge = StripeWrapper::Charge.create(donation_params.to_h)
      if charge.successful?
        head :ok
      else
        render json: {error: charge.error_message}, status: :unprocessable_entity
      end
    end

    private

    def donation_params
      params.require(:donation).permit(
        :description,
        :amount,
        :currency,
        :source
      )
    end
  end
end
