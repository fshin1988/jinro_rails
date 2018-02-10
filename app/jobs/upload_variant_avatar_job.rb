class UploadVariantAvatarJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.avatar.variant(resize: "100x100").processed
  end
end
