require 'rails' # from railties
require 'active_record'
require 'action_controller'
require 'rbconfig'
require 'truncate_html'
require 'will_paginate'

module Refinery
  WINDOWS = !!(RbConfig::CONFIG['host_os'] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  require 'refinery/errors'

  autoload :Activity, 'refinery/activity'
  autoload :ApplicationController, 'refinery/application_controller'
  autoload :Engine, 'refinery/engine'
  autoload :Menu, 'refinery/menu'
  autoload :MenuItem, 'refinery/menu_item'
  autoload :Plugin,  'refinery/plugin'
  autoload :Plugins, 'refinery/plugins'
  autoload :Version, 'refinery/version'
  autoload :Crud, 'refinery/crud'
  autoload :BasePresenter, 'refinery/base_presenter'

  require 'refinery/ext/action_view/helpers/form_builder'
  require 'refinery/ext/action_view/helpers/form_helper'
  require 'refinery/ext/action_view/helpers/form_tag_helper'

  module Admin
    autoload :BaseController, 'refinery/admin/base_controller'
  end

  autoload :CmsGenerator, 'generators/refinery/cms/cms_generator'
  autoload :DummyGenerator, 'generators/refinery/dummy/dummy_generator'
  autoload :CoreGenerator, 'generators/refinery/core/core_generator'
  autoload :EngineGenerator, 'generators/refinery/engine/engine_generator'

  class << self
    @@extensions = []

    # Returns an array of modules representing currently registered Refinery Engines
    #
    # Example:
    #   Refinery.extensions  =>  [Refinery::Core, Refinery::Pages]
    def extensions
      @@extensions
    end

    # Register an extension with Refinery
    #
    # Example:
    #   Refinery.register_extension(Refinery::Core)
    def register_extension(const)
      return if extension_registered?(const)

      validate_extension!(const)

      @@extensions << const
    end
    alias_method :register_engine, :register_extension

    # Unregister an extension from Refinery
    #
    # Example:
    #   Refinery.unregister_extension(Refinery::Core)
    def unregister_extension(const)
      @@extensions.delete(const)
    end

    # Returns true if an extension is currently registered with Refinery
    #
    # Example:
    #   Refinery.extension_registered?(Refinery::Core)
    def extension_registered?(const)
      @@extensions.include?(const)
    end

    # Constructs a deprecation warning message and warns with Kernel#warn
    #
    # Example:
    #   Refinery.deprecate('foo') => "The use of 'foo' is deprecated"
    #
    # An options parameter can be specified to construct a more detailed deprecation message
    #
    # Options:
    #   when - version that this deprecated feature will be removed
    #   replacement - a replacement for what is being deprecated
    #   caller - who called the deprecated feature
    #
    # Example:
    #   Refinery.deprecate('foo', :when => 'tomorrow', :replacement => 'bar') =>
    #       "The use of 'foo' is deprecated and will be removed at version 2.0. Please use 'bar' instead."
    def deprecate(what, options = {})
      # Build a warning.
      warning = "\n-- DEPRECATION WARNING --\n"
      warning << "The use of '#{what}' is deprecated"
      warning << " and will be removed at version #{options[:when]}" if options[:when]
      warning << "."
      warning << "\nPlease use #{options[:replacement]} instead." if options[:replacement]

      # See if we can trace where this happened
      if options[:caller]
        whos_calling = options[:caller].detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first
        warning << "\nCalled from: #{whos_calling}\n"
      end

      # Give stern talking to.
      warn warning
    end

    def i18n_enabled?
      !!(defined?(::Refinery::I18n) && ::Refinery::I18n.enabled?)
    end

    # Returns a Pathname to the root of the Refinery CMS project
    def root
      @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end

    # Returns an array of Pathnames pointing to the root directory of each extension that
    # has been registered with Refinery.
    #
    # Example:
    #   Refinery.roots => [#<Pathname:/Users/Reset/Code/refinerycms/core>, #<Pathname:/Users/Reset/Code/refinerycms/pages>]
    #
    # An optional extension_name parameter can be specified to return just the Pathname for
    # the specified extension. This can be represented in Constant, Symbol, or String form.
    #
    # Example:
    #   Refinery.roots(Refinery::Core)    =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    #   Refinery.roots(:'refinery/core')  =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    #   Refinery.roots("refinery/core")   =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    def roots(extension_name = nil)
      return @roots ||= self.extensions.map { |extension| extension.root } if extension_name.nil?

      extension_name.to_s.camelize.constantize.root
    end

    def version
      Refinery::Version.to_s
    end

    # Returns string version of url helper path. We need this to temporary support namespaces
    # like Refinery::Image and Refinery::Blog::Post
    #
    # Example:
    #   Refinery.route_for_model("Refinery::Image") => "admin_image_path"
    #   Refinery.route_for_model(Refinery::Image, true) => "admin_images_path"
    #   Refinery.route_for_model(Refinery::Blog::Post) => "blog_admin_post_path"
    #   Refinery.route_for_model(Refinery::Blog::Post, true) => "blog_admin_posts_path"
    def route_for_model(klass, plural = false)
      parts = klass.to_s.underscore.split('/').delete_if { |p| p.blank? }

      resource_name = plural ? parts[-1].pluralize : parts[-1]

      if parts.size == 2
        "admin_#{resource_name}_path"
      elsif parts.size > 2
        [parts[1..-2].join("_"), "admin", resource_name, "path"].join("_")
      end
    end

    def include_unless_included(base, extension_module)
      base.send :include, extension_module unless included_extension_module?(base, extension_module)
    end

  private
    # plain Module#included? or Module#included_modules doesn't cut it here
    def included_extension_module?(base, extension_module)
      if base.kind_of?(Class)
        direct_superclass = base.superclass
        base.ancestors.take_while {|ancestor| ancestor != direct_superclass}.include?(extension_module)
      else
        base < extension_module # can't do better than that for modules
      end
    end

    def validate_extension!(const)
      unless const.respond_to?(:root) && const.root.is_a?(Pathname)
        raise InvalidEngineError, "Engine must define a root accessor that returns a pathname to its root"
      end
    end
  end

  module Core
    require 'refinery/core/engine'
    require 'refinery/core/configuration'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
