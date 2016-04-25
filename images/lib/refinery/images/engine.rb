module Refinery
  module Images
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_images

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'attach-refinery-images-with-dragonfly', :before => :finisher_hook do |app|
        ::Refinery::Images::Dragonfly.configure!
        ::Refinery::Images::Dragonfly.attach!(app)
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_images'
          plugin.icon = 'icon icon-photo bump-down'
          plugin.menu_match = %r{refinery/image(_dialog)?s$}
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_images_path }
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Images)
      end
    end
  end
end
