class ActiveStorage::RepresentationsController < ActiveStorage::BaseController
  include ActiveStorage::SetBlob

  def show
    expires_in 120.minutes
    representation = @blob.representation(params[:variation_key])
    # Wait until UploadVariantAvatarJob finishes
    count = 0
    until representation.send(:processed?) || count > 10
      sleep 1
      count += 1
    end

    if count > 10
      head :not_found
    else
      redirect_to representation.service_url(expires_in: 120.minutes, disposition: params[:disposition])
    end
  end
end
