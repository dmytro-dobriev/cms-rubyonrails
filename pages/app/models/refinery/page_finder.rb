module Refinery
  class PageFinder
    def self.find_by_path(path)
      PageFinderByPath.new(path).find
    end

    def self.find_by_path_or_id(path, id)
      PageFinderByPathOrId.new(path, id).find
    end

    def self.by_title(title)
      PageFinderByTitle.new(title).find
    end

    def self.by_slug(slug, conditions={})
      PageFinderBySlug.new(slug, conditions).find
    end

    def self.with_globalize(conditions = {})
      PageFinder.new.with_globalize(conditions)
    end

    def with_globalize(conditions)
      conditions = {:locale => ::Globalize.locale.to_s}.merge(conditions)
      translations_conditions = translations_conditions(conditions)

      # A join implies readonly which we don't really want.
      Page.where(conditions).joins(:translations).where(translations_conditions).
                                             readonly(false)
    end

    private

    def translated_attributes
      Page.translated_attribute_names.map(&:to_s) | %w(locale)
    end

    def translations_conditions(conditions)
      translations_conditions = {}
      conditions.keys.each do |key|
        if translated_attributes.include? key.to_s
          translations_conditions["#{Page.translation_class.table_name}.#{key}"] = conditions.delete(key)
        end
      end
      translations_conditions
    end

  end

  class PageFinderByTitle < PageFinder
    def initialize(title)
      @title = title
    end

    def find
      with_globalize(default_conditions)
    end

    def default_conditions
      { :title => @title }
    end
  end

  class PageFinderBySlug < PageFinder
    def initialize(slug, conditions)
      @slug = slug
      @conditions = conditions
    end

    def find
      with_globalize( default_conditions.merge(@conditions) )
    end

    def default_conditions
      {
        :locale => Refinery::I18n.frontend_locales.map(&:to_s),
        :slug => @slug
      }
    end
  end

  class PageFinderByPath
    def initialize(path)
      @path = path
    end

    def find
      if slugs_scoped_by_parent?
        find_scoped_slug
      else
        find_unscoped_slug
      end
    end

    private

    def slugs_scoped_by_parent?
      ::Refinery::Pages.scope_slug_by_parent
    end

    def find_scoped_slug
      # With slugs scoped to the parent page we need to find a page by its full path.
      # For example with about/example we would need to find 'about' and then its child
      # called 'example' otherwise it may clash with another page called /example.
      path = @path.split('/').select(&:present?)
      page = by_slug(path.shift, :parent_id => nil).first
      while page && path.any? do
        slug_or_id = path.shift
        page = page.children.by_slug(slug_or_id).first || page.children.find(slug_or_id)
      end
      page
    end

    def find_unscoped_slug
      by_slug(@path).first
    end

    def by_slug(path, conditions = {})
      PageFinder.by_slug(path, conditions)
    end
  end

  class PageFinderByPathOrId
    def initialize(path, id)
      @path = path
      @id = id
    end

    def find
      if @path.present?
        if @path.friendly_id?
          Page.friendly.find_by_path(@path)
        else
          Page.friendly.find(@path)
        end
      elsif @id.present?
        Page.friendly.find(@id)
      end
    end
  end
end