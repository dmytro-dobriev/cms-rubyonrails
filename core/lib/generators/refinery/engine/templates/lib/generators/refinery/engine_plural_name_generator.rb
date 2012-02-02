module Refinery
  class <%= engine_plural_class_name %>Generator < Rails::Generators::Base

    source_root File.expand_path('../../../../', __FILE__)

    def rake_db
      rake("refinery_<%= engine_plural_name %>:install:migrations")
    end

  end
end
