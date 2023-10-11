# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class FoxTail::TranslatorTest < Minitest::Test
  def test_model
    translator = FoxTail::Translator.new User.new, "user", :first_name
    assert_instance_of User, translator.model
  end

  def test_model_nil
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name
    assert_nil translator.model
  end

  def test_object_name
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name
    assert_equal "user", translator.object_name
  end

  def test_object_name_from_attributes
    translator = FoxTail::Translator.new OpenStruct.new, "posts[user_attributes][1]", :first_name
    assert_equal "posts.user", translator.object_name
  end

  def test_method
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name
    assert_equal :first_name, translator.method
  end

  def test_value
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name, value: "John"
    assert_equal "John", translator.value
  end

  def test_scope
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name, scope: "posts"
    assert_equal "posts", translator.scope
  end

  def test_default_value
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name
    assert_equal "", translator.default_value
  end

  def test_custom_default_value
    translator = FoxTail::Translator.new OpenStruct.new, "user", :first_name, default: "Foo Bar"
    assert_equal "Foo Bar", translator.default_value
  end

  def test_empty_method_name
    translator = FoxTail::Translator.new User.new, "user", nil
    assert_empty translator.translate
  end

  def test_translation
    skip "Need to find a away to successfully mock the method I18n.translate"
  end
end
