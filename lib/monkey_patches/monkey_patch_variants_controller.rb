module ExtendVariantsController
  def show
    if blob = ActiveStorage::Blob.find_signed(params[:signed_blob_id])
      expires_in 120.minutes
      variant = ActiveStorage::Variant.new(blob, params[:variation_key])
      # Wait until UploadVariantAvatarJob finishes
      count = 0
      until variant.send(:processed?) || count > 10
        sleep 1
        count += 1
      end
      redirect_to variant.processed.service_url(expires_in: 120.minutes, disposition: params[:disposition])
    else
      head :not_found
    end
  end
end

class ActiveStorage::VariantsController < ActionController::Base
  prepend ExtendVariantsController
end
