# frozen_string_literal: true

require "test_helper"

module FoxTail
  module IconSets
    class HeroIconSetTest < ActiveSupport::TestCase
      def subject
        FoxTail::IconSets::HeroIconSet.new "heroicons"
      end

      def test_name_is_set
        assert_equal "heroicons", subject.name
      end

      def test_path_to_solid_home_is_valid
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons/24/solid/home.svg"), subject.path(:home, variant: :solid)
      end

      def test_path_to_outline_home_is_valid
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons/24/outline/home.svg"), subject.path(:home, variant: :outline)
      end

      def test_path_to_mini_home_is_valid
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons/20/solid/home.svg"), subject.path(:home, variant: :mini)
      end

      def test_path_to_micro_home_is_valid
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons/16/solid/home.svg"), subject.path(:home, variant: :micro)
      end

      def test_path_formats_underscores
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons/24/solid/badge-check.svg"), subject.path(:badge_check, variant: :solid)
      end

      def test_path_raises_invalid_icon_set_variant
        assert_raises FoxTail::InvalidIconSetVariant do
          subject.path :home, variant: :foo_bar
        end
      end

      def test_root_path_gem_assets_path
        assert_equal FoxTail.root.join("app/assets/vendor/heroicons"), subject.root_path
      end
    end
  end
end
