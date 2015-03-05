# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host "maymay.in"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :about do
  url about_path, last_mod: Time.now, change_freq: "monthly", priority: 0.9
end
sitemap :api do
  url api_path, last_mod: Time.now, change_freq: "monthly", priority: 0.9
end

sitemap :login do
  url new_user_session_path, last_mod: Time.now, change_freq: "monthly", priority: 0.6
end

sitemap :templates do
  url templates_path, last_mod: Time.now, change_freq: "daily", priority: 0.8
end
sitemap :generator do
  url generator_random_path, last_mod: Time.now, change_freq: "daily", priority: 0.8
end
sitemap :memes do
  url memes_with_page_path(0), last_mod: Time.now, change_freq: "hourly", priority: 0.9
end

sitemap_for Meme.all, name: :memes_list do |meme|
  slug = meme.meme_slugs.order(main: :desc).limit(1).first.slug
  url memes_with_meme_and_page_path(slug, 0)
end

sitemap_for Meme.all, name: :memes_generator_list do |meme|
  slug = meme.meme_slugs.order(main: :desc).limit(1).first.slug
  url generator_path(slug)
end

sitemap :top_users do
  url top_users_path, last_mod: Time.now, change_freq: "daily", priority: 0.7
end

sitemap :terms_of_use do
  url terms_of_use_path, last_mod: Time.now, change_freq: "yearly", priority: 0.3
end
sitemap :privacy_policy do
  url privacy_policy_path, last_mod: Time.now, change_freq: "yearly", priority: 0.3
end

# You can have multiple sitemaps like the above – just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
#   sitemap_for Page.scoped

# For products with special sitemap name and priority, and link to comments:
#
#   sitemap_for Product.published, name: :published_products do |product|
#     url product, last_mod: product.updated_at, priority: (product.featured? ? 1.0 : 0.7)
#     url product_comments_url(product)
#   end

# If you want to generate multiple sitemaps in different folders (for example if you have
# more than one domain, you can specify a folder before the sitemap definitions:
# 
#   Site.all.each do |site|
#     folder "sitemaps/#{site.domain}"
#     host site.domain
#     
#     sitemap :site do
#       url root_url
#     end
# 
#     sitemap_for site.products.scoped
#   end

ping_with "http://#{host}/sitemap.xml"