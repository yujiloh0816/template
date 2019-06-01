# rspec_template.rb

txt = <<-TXT

      ＿人人人人人人人人人人人人人人人人人人＿
      ＞　Rails Application Templates　＜
      ￣Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^YY^Y￣

TXT
puts txt

# Gemfileに追加

# 01 未完成
# gem 'bootstrap'
# gem 'jquery-rails'

# 02 未完成
# comment_lines 'Gemfile', "gem 'webdrivers'"
# uncomment_lines 'Gemfile', "gem 'chromedriver-helper'"

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  # gem 'simplecov' if yes?('use simplecov ?')
end

gem_group :development do
  gem 'spring-commands-rspec'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'faker', require: false
end

gem_group :test do
  gem 'launchy'
end

# 01 bootstrap初期設定 未完成
# run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss'
#insert_into_file 'app/assets/stylesheets/application.scss', '@import "bootstrap";'


# rspec初期設定
run 'bundle install'
run 'rm -rf test'
generate 'rspec:install'
append_to_file '.rspec', '--format documentation'
insert_into_file 'spec/rails_helper.rb',
after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
  <<-CODE
  require 'capybara/rspec'
  CODE
end

# factory_bot初期設定
uncomment_lines 'spec/rails_helper.rb', /Dir\[Rails\.root\.join/
  get "~/{template へのパスを記述}/template/spec/support/factory_bot.rb", 'spec/support/factory_bot.rb'

# spring-commands-rspec初期設定
run 'bundle exec spring binstub rspec'

# better_errors初期設定
insert_into_file 'config/environments/development.rb',
 after: "config.file_watcher = ActiveSupport::EventedFileUpdateChecker\n" do
   <<-CODE

   # better_errors初期設定
   if defined?(BetterErrors) && ENV["SSH_CLIENT"]
     host = ENV["SSH_CLIENT"].match(/\A([^\s]*)/)[1]
     BetterErrors::Middleware.allow_ip! host if host
   end
   CODE
end

# application.rb初期設定
insert_into_file 'config/application.rb',
after: "# the framework and any gems in your application.\n" do
  <<-CODE

    # Rouesを生成しない
    config.generators do |g|
      g.skip_routes true
    end

    # 表示時のタイムゾーンをJSTに設定
    config.time_zone = 'Tokyo'
    # DB保存時のタイムゾーンをJSTに設定
    config.active_record.default_timezone = :local
  CODE
end

gitignore = <<-CODE
# .DS_Store
CODE

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
