# frozen_string_literal: true

require 'test_helper'

module FoxTail
  module IconSets
    class BaseTest < Minitest::Test
      def subject
        FoxTail::IconSets::Base.new "test-icons"
      end

      def test_name_is_set
        assert_equal "test-icons", subject.name
      end

      def test_path_raises_not_implemented
        assert_raises NotImplementedError do
          subject.path :home
        end
      end

      def test_root_path_raises_not_implement
        assert_raises NotImplementedError do
          subject.root_path
        end
      end
    end
  end
end
