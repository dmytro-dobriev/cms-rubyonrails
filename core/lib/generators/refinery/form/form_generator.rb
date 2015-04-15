require 'refinery/extension_generation'
require 'refinery/generators/named_base'

module Refinery
  class FormGenerator < Refinery::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    include Refinery::ExtensionGeneration

    def description
      "Generates an extension which is set up for frontend form submissions like a contact page."
    end

    def generate
      default_generate!
    end

    protected

    def generator_command
      'rails generate refinery:form'
    end
  end
end
