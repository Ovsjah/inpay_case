class PaymentRequestsController < ApplicationController
  def index
    render json: PaymentRequest.select(:id, :full_name, :amount, :currency, :status)
  end

  def create
    payment_request = PaymentRequest.new(payment_request_params)
    if payment_request.save
      render json: payment_request, status: :created
    else
      render json: payment_request.errors.full_messages, status: :bad_request
    end
  end

  def show
    if payment_request = PaymentRequest.find_by_id(params[:id])
      render json: payment_request
    else
      render json: { message: "Sorry, but there is no payment request with provided id."}, status: :not_found
    end
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:full_name, :amount, :currency, :iban)
  end
end
