# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Infinum
      # This cop looks for 'association' in factories that specify a ':factory' option
      # and tells you to use explicit build reference which improves the performance
      # as cascading factories will not be saved unless needed to
      #
      # @example
      #   #bad
      #    FactoryBot.define do
      #      factory :book do
      #        title { 'Lord of the Rings' }
      #        association :author
      #      end
      #    end
      #
      #    FactoryBoy.define do
      #      factory :book do
      #        title {'Lord of the Rings'}
      #        author { association :author }
      #      end
      #    end
      #
      #    #good
      #    FactoryBot.define do
      #      factory :book do
      #        title { 'Lord of the Rings' }
      #        author { build(:author) }
      #      end
      #    end
      #
      #    FactoryBot.define do
      #      factory :author do
      #        name { 'J. R. R. Tolkien' }
      #      end
      #    end
      class FactoryBotAssociation < ::RuboCop::Cop::Cop
        MSG = 'Use %<association_name>s { build(:%<factory_name>s) } instead'

        def_node_matcher :association_definition, <<~PATTERN
          (send nil? :association (:sym $_) (hash (pair (sym :factory) (:sym $_))) ?)
        PATTERN

        def_node_matcher :inline_association_definition, <<~PATTERN
          (block (send nil? $_) (args) (send nil? :association (sym $_)))
        PATTERN

        def on_block(node)
          inline_association_definition(node) do |association_name, factory_name|
            message = format(MSG, association_name: association_name.to_s, factory_name: factory_name.to_s)

            add_offense(node, location: node, message: message)
          end
        end

        def on_send(node)
          return unless corrections.empty?

          association_definition(node) do |association_name, factory_name|
            factory_name = [association_name] if factory_name.empty?

            message = format(MSG, association_name: association_name.to_s, factory_name: factory_name.first.to_s)

            add_offense(node, location: node, message: message)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            if expression(node).size == 1
              corrector.replace(node, "#{expression(node)[0]} { build(:#{expression(node)[0]}) }")
            else
              corrector.replace(node, "#{expression(node)[0]} { build(:#{expression(node)[1]}) }")
            end
          end
        end

        private

        def expression(node)
          @expression = if node.block_type?
                          inline_association_definition(node)
                        else
                          association_definition(node).flatten
                        end
        end
      end
    end
  end
end
