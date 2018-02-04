module ExtendVariantsController
  def show
    if blob = ActiveStorage::Blob.find_signed(params[:signed_blob_id])
      expires_in 120.minutes
      variant = ActiveStorage::Variant.new(blob, params[:variation_key])
      # Wait until UploadVariantAvatarJob finishes
      until variant.send(:processed?)
        sleep 1
      end
      redirect_to variant.service_url(expires_in: 120.minutes, disposition: params[:disposition])
    else
      head :not_found
    end
  end
end

class ActiveStorage::VariantsController < ActionController::Base
  prepend ExtendVariantsController
end
