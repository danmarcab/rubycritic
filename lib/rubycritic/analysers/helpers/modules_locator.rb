# frozen_string_literal: true
require 'rubycritic/analysers/helpers/parser'

module RubyCritic
  class ModulesLocator
    def initialize(analysed_module)
      @analysed_module = analysed_module
    end

    def main_module_name
      main_name = names.find do |name|
        name.split('::').last == classified_filename
      end

      main_name || classified_filename
    end

    def names
      names = node.get_module_names
      if names.empty?
        [classified_filename]
      else
        names
      end
    end

    private

    def node
      Parser.parse(content)
    end

    def content
      File.read(@analysed_module.path)
    end

    def file_name
      @analysed_module.pathname.basename.sub_ext('').to_s
    end

    def classified_filename
      file_name.split('_').map(&:capitalize).join
    end
  end
end
