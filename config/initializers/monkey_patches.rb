Dir[Rails.root.join('lib/monkey_patches/**/*.rb')].sort.each do |file|
  require file
end
