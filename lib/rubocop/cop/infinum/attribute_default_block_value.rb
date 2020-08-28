# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Infinum
      # This cop looks for `attribute` class methods that don't
      # specify a `:default` option inside a block.
      #
      # @example
      #   # bad
      #   class User < ApplicationRecord
      #     attribute :confirmed_at, :datetime, default: Time.zone.now
      #   end
      #
      #   # good
      #   class User < ActiveRecord::Base
      #     attribute :confirmed_at, :datetime, default: -> { Time.zone.now }
      #   end
      class AttributeDefaultBlockValue < ::RuboCop::Cop::Cop
        MSG = 'Pass a block to `:default` option.'

        def_node_search :active_resource_class?, <<~PATTERN
          (const (const nil? :ActiveResource) :Base)
        PATTERN

        def_node_matcher :attribute?, '(send nil? :attribute _ _ $hash)'

        def on_send(node)
          return if active_resource?(node.parent)

          attribute?(node) do |third_arg|
            default_attribute = default_attribute(third_arg)

            unless [:block, :true, :false].include?(default_attribute.children.last.type) # rubocop:disable Lint/BooleanSymbol
              add_offense(node, location: default_attribute)
            end
          end
        end

        private

        def active_resource?(node)
          return false if node.nil?

          active_resource_class?(node)
        end

        def default_attribute(node)
          node.children.first
        end
      end
    end
  end
end
