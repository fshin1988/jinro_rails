class UploadVariantAvatarJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveStorage::InvariableError) do
    nil
  end

  def perform(owner)
    owner.avatar.variant(resize: "100x100").processed
  end
end
