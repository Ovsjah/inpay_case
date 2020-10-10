require 'rails_helper'

RSpec.describe "PaymentRequests", type: :request do
  let(:valid_params) { { payment_request: {full_name: "Stinky Wizzleteats",
                                              amount: 777.88,
                                              currency: "USD",
                                              iban: "GB82 WEST 1234 5698 7654 32"} } }
  let(:invalid_params) { { payment_request: {full_name: '', amount: '', currency: '', iban: ''} } }
  let!(:payment_request) { PaymentRequest.create(valid_params[:payment_request]) }

  it "creates a payment request and returns the result" do
    expect {
      post "/payment_requests", params: valid_params
    }.to change(PaymentRequest, :count).by(1)
    expect(response).to have_http_status(:created)
  end

  it "validates the payment request" do
    post "/payment_requests", params: invalid_params
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq("[\"Full name can't be blank\",\"Amount is not a number\",\"Currency must be in USD, EUR or GBP!\",\"Iban is invalid\"]")
  end

  it "shows the previously created payment request" do
    get "/payment_requests/#{payment_request.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("\"id\":1,\"full_name\":\"Stinky Wizzleteats\",\"amount\":777.88,\"currency\":\"USD\",\"iban\":\"GB82 WEST 1234 5698 7654 32\",\"status\":\"pending\"")
  end

  it "provides descriptive error message if payment request isn't found" do
    get "/payment_requests/666"
    expect(response).to have_http_status(:not_found)
    expect(response.body).to eq("{\"message\":\"Sorry, but there is no payment request with provided id.\"}")
  end

  it "queries for the statuses of previously created payments" do
    get "/payment_requests"
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("[{\"id\":1,\"full_name\":\"Stinky Wizzleteats\",\"amount\":777.88,\"currency\":\"USD\",\"status\":\"pending\"}]")
  end
end
