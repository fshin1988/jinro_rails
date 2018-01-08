SitemapGenerator::Sitemap.default_host = "https://#{ENV['HOST_NAME']}"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-ap-northeast-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY'],
  aws_secret_access_key: ENV['AWS_SECRET_KEY'],
  aws_region: ENV['AWS_REGION']
)

SitemapGenerator::Sitemap.create do
  add villages_path, priority: 0.8, changefreq: 'daily'
  add manual_path(Manual.first), priority: 0.5
  add new_user_session_path, priority: 0.6
  add new_user_registration_path, priority: 0.9

  Village.where(status: 'ended').each do |village|
    add village_room_path(village, village.room_for_all), priority: 0.7
  end
end
