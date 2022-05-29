namespace :ruin_expired_villages do
  task execute: :environment do
    now = Time.zone.now.to_date
    Village.not_started.where('start_at < ?', now - 30.days).each do |village|
      village.update(status: :ruined)
      village.post_system_message("#{village.name}は廃村になりました")
    end
  end
end
