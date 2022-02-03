# frozen_string_literal: true

require "active_support/all"
require_relative "hasharay_ext/version"

module HasharayExt
  class Error < StandardError; end

  module Interface
    def fpath!(path, separator: ".", default: nil)
      fpath(path, strict: true, separator: separator, default: default)
    end
    alias_method :fetch_path!, :fpath!
  end

  class Logic
    attr_reader :data, :strict, :separator, :default

    def initialize(data, strict: true, separator: ".", default: nil)
      @data = data
      @strict = strict
      @separator = separator
      @default = default
    end

    def get(path)
      raise ArgumentError.new("Not specified key") if path.blank?

      object = data.clone
      tree = path.split(separator)

      tree.each_with_index do |raw, index|
        raise ArgumentError.new("Not specified key") if raw.blank?

        keywords = raw.split("+")
        if index == (tree.size - 1) && keywords.size > 1
          # last iteration
          case object
          when Array
            return keywords.map do |keyword|
              fetch(object, keyword)
            end.transpose
          when Hash
            return keywords.each_with_object({}) { |e, res|
                     res[e] = fetch(object, e)
                   }
          end
        else
          # every key
          object = fetch(object, raw)
        end
      end
      object
    end

    private

    def fetch(object, key)
      case object
      when Hash
        e = object.fetch(key, strict ? invalid_key!(key, object) : default)
        if e.is_a?(Proc)
          e.call
        else
          object = e
        end
      when Array
        object = object.fpath(key, strict: strict, separator: separator)
      end
      object
    end

    def invalid_key!(key, object)
      proc { raise(ArgumentError.new("Key `#{key}` not found on attribute ##{object} strict: #{strict}, separator: #{separator}")) }
    end
  end
end

class Array
  include HasharayExt::Interface

  def fpath(key, strict: false, separator: ".", default: nil)
    map do |e|
      e.present? ? e.fpath(key, strict: strict, separator: separator, default: default) : default
    end
  end
  alias_method :fetch_path, :fpath
end

class Hash
  include HasharayExt::Interface

  def fpath(path, strict: false, separator: ".", default: nil)
    HasharayExt::Logic.new(clone.deep_stringify_keys, strict: strict, separator: separator, default: default).get(path)
  end
  alias_method :fetch_path, :fpath
end
