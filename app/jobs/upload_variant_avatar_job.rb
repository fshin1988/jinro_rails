class UploadVariantAvatarJob < ApplicationJob
  queue_as :default

  def perform(owner)
    owner.avatar.variant(resize: "100x100").processed
  end
end
