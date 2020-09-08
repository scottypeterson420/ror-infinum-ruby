# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Infinum
      # This cop looks for `attribute` class methods that specify a `:default` option
      # and pass it a method without a block.
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
        MSG = 'Pass method in a block to `:default` option.'

        def_node_matcher :default_attribute, <<~PATTERN
          (send nil? :attribute _ _ (hash <$#attribute ...>))
        PATTERN

        def_node_matcher :attribute, '(pair (sym :default) $_)'

        def on_send(node)
          default_attribute(node) do |attribute|
            value = attribute.children.last

            add_offense(node, location: value) if value.send_type?
          end
        end

        def autocorrect(node)
          expression = default_attribute(node).children.last

          lambda do |corrector|
            corrector.replace(expression, "-> { #{expression.source} }")
          end
        end
      end
    end
  end
end
