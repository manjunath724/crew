require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crew
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    # Ref: https://github.com/que-rb/que#additional-rails-specific-setup
    # Ref: https://guides.rubyonrails.org/active_record_migrations.html#types-of-schema-dumps
    # Ref: https://github.com/que-rb/que/tree/master/docs#multiple-queues
    config.active_record.schema_format = :sql

    config.action_mailer.deliver_later_queue_name = :default
    config.action_mailbox.queues.incineration = :default
    config.action_mailbox.queues.routing = :default
    config.active_storage.queues.analysis = :default
    config.active_storage.queues.purge = :default

    config.active_job.queue_adapter = :que
  end
end
