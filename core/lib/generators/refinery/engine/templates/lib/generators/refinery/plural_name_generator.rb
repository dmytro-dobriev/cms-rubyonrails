module Refinery
  class <%= class_name.pluralize %>Generator < Rails::Generators::Base

    source_root File.expand_path('../../../', __FILE__)

    def rake_db
        rake("refinery_<%= class_name.pluralize %>:install:migrations")
    end
  end
end