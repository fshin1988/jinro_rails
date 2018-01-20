class ActiveStorage::VariantsController < ActionController::Base
  def show
    if blob = ActiveStorage::Blob.find_signed(params[:signed_blob_id])
      logger.info "Using customized VariantsController"
      expires_in 120.minutes
      redirect_to ActiveStorage::Variant.new(blob, params[:variation_key]).processed.service_url(expires_in: 120.minutes, disposition: params[:disposition])
    else
      head :not_found
    end
  end
end
