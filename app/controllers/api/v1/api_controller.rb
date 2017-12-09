class Api::V1::ApiController < ApplicationController
  private

  def redirect_to_root
    head :bad_request
  end
end
