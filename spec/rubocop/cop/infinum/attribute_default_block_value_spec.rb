# frozen_string_literal: true

RSpec.describe(RuboCop::Cop::Infinum::AttributeDefaultBlockValue, :config) do
  subject(:cop) { described_class.new(config) }

  let(:message) { 'Pass a block to `:default` option.' }

  describe('offenses') do
    it('disallows symbol') do
      expect_offense(<<~RUBY)
        attribute :foo, :string, default: :bar
                                 ^^^^^^^^^^^^^ #{message}
      RUBY
    end

    it('disallows constant') do
      expect_offense(<<~RUBY)
        CONSTANT = :foo
        attribute :bar, :string, default: CONSTANT
                                 ^^^^^^^^^^^^^^^^^ #{message}
      RUBY
    end

    it('disallows method') do
      expect_offense(<<~RUBY)
        attribute :foo, :string, default: bar
                                 ^^^^^^^^^^^^ #{message}
      RUBY
    end

    it('disallows method called from other class') do
      expect_offense(<<~RUBY)
        attribute :foo, :string, default: Time.zone.now
                                 ^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY
    end

    it('allows boolean false') do
      expect_no_offenses(<<~RUBY)
        attribute :foo, :string, default: false
      RUBY
    end

    it('allows boolean true') do
      expect_no_offenses(<<~RUBY)
        attribute :foo, :string, default: true
      RUBY
    end

    it('allows block') do
      expect_no_offenses(<<~RUBY)
        attribute :foo, :string, default: -> { Time.zone.now }
      RUBY
    end

    context 'when default option in new row' do
      it('properly highlights violation') do
        expect_offense(<<~RUBY)
          attribute :foo,
                    :string,
                    default: :bar
                    ^^^^^^^^^^^^^ #{message}
        RUBY
      end
    end
  end
end
