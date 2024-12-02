# frozen_string_literal: true

require "test_helper"

class HtmlAttributesTest < ActiveSupport::TestCase
  def boolean_attributes
    %w[
      allowfullscreen allowpaymentrequest async autofocus autoplay checked compact controls declare default
      defaultchecked defaultmuted defaultselected defer disabled enabled formnovalidate hidden indeterminate
      inert ismap itemscope loop multiple muted nohref nomodule noresize noshade novalidate nowrap open
      pauseonexit playsinline readonly required reversed scoped seamless selected sortable truespeed
      typemustmatch visible
    ].freeze
  end

  test "#merge_classes" do
    attributes = FoxTail::HtmlAttributes.new(class: "mb-4 text-primary-500")
    merged = attributes.merge_classes "mb-8 text-primary-600 p-5"

    assert_not_same attributes, merged
    assert_equal "mb-8 text-primary-600 p-5", merged[:class]
  end

  test "#merge_classes!" do
    attributes = FoxTail::HtmlAttributes.new(class: "mb-4 text-primary-500")
    merged = attributes.merge_classes! "mb-8 text-primary-600 p-5"

    assert_same attributes, merged
    assert_equal "mb-8 text-primary-600 p-5", attributes[:class]
  end

  test "#merge_stimulus_controllers" do
    attributes = FoxTail::HtmlAttributes.new(data: {controller: "fox-tail--progress-bar"})
    merged = attributes.merge_stimulus_controllers("fox-tail--form-item", "foo-bar", ["fox-tail--progress-bar"])


    assert_not_same attributes, merged
    assert_equal "fox-tail--progress-bar fox-tail--form-item foo-bar", merged.dig(:data, :controller)
  end

  test "#merge_stimulus_controllers!" do
    attributes = FoxTail::HtmlAttributes.new(data: {controller: "fox-tail--progress-bar"})
    merged = attributes.merge_stimulus_controllers!("fox-tail--form-item", "foo-bar", ["fox-tail--progress-bar"])

    assert_same attributes, merged
    assert_equal "fox-tail--progress-bar fox-tail--form-item foo-bar", merged.dig(:data, :controller)
  end

  test "#merge_stimulus_actions" do
    attributes = FoxTail::HtmlAttributes.new(data: {action: "fox-tail--progress-bar:updated->foo-bar#update"})
    merged = attributes.merge_stimulus_actions("fox-tail--progress-bar:updated->foo-bar#update", ["foo-bar#click"])

    assert_not_same attributes, merged
    assert_equal "fox-tail--progress-bar:updated->foo-bar#update foo-bar#click", merged.dig(:data, :action)
  end

  test "#merge_stimulus_actions!" do
    attributes = FoxTail::HtmlAttributes.new(data: {controller: "fox-tail--progress-bar"})
    merged = attributes.merge_stimulus_actions!("fox-tail--progress-bar:updated->foo-bar#update", ["foo-bar#click"])

    assert_same attributes, merged
    assert_equal "fox-tail--progress-bar:updated->foo-bar#update foo-bar#click", merged.dig(:data, :action)
  end

  test "#merge_stimulus" do
    attributes = FoxTail::HtmlAttributes.new(
      class: "mb-4 text-primary-600 p-5",
      data: {
        controller: "fox-tail--progress-bar",
        fox_tail__progress_bar_val_value: 50,
        action: "hover->fox-tail--progress-bar:update"
      },
      aria: {
        visible: true
      },
      type: :progress,
      min: 0,
      max: 100
    )

    merged = attributes.merge_stimulus controller: "foo-bar", foo_bar_out_outlet: ".foo-bar-outlet", action: "foo-bar#update"

    assert_not_same attributes, merged
    assert_equal(
      {
        "class" => "mb-4 text-primary-600 p-5",
        "data" => {
          "controller" => "fox-tail--progress-bar foo-bar",
          "fox_tail__progress_bar_val_value" => 50,
          "action" => "hover->fox-tail--progress-bar:update foo-bar#update",
          "foo_bar_out_outlet" => ".foo-bar-outlet",
        },
        "aria" => {
          "visible" => true
        },
        "type" => :progress,
        "min" => 0,
        "max" => 100
      },
      merged
    )
  end

  test "#merge_stimulus!" do
    attributes = FoxTail::HtmlAttributes.new(
      class: "mb-4 text-primary-600 p-5",
      data: {
        controller: "fox-tail--progress-bar",
        fox_tail__progress_bar_val_value: 50,
        action: "hover->fox-tail--progress-bar:update"
      },
      aria: {
        visible: true
      },
      type: :progress,
      min: 0,
      max: 100
    )

    merged = attributes.merge_stimulus! controller: "foo-bar", foo_bar_out_outlet: ".foo-bar-outlet", action: "foo-bar#update"

    assert_same attributes, merged
    assert_equal(
      {
        "class" => "mb-4 text-primary-600 p-5",
        "data" => {
          "controller" => "fox-tail--progress-bar foo-bar",
          "fox_tail__progress_bar_val_value" => 50,
          "action" => "hover->fox-tail--progress-bar:update foo-bar#update",
          "foo_bar_out_outlet" => ".foo-bar-outlet",
        },
        "aria" => {
          "visible" => true
        },
        "type" => :progress,
        "min" => 0,
        "max" => 100
      },
      merged
    )
  end

  test "#to_attributes formats boolean attributes to [attr]='attr' when true" do
    attributes = FoxTail::HtmlAttributes.new(boolean_attributes.index_with(true)).to_attributes

    boolean_attributes.each do |attr|
      assert_equal attr, attributes[attr], "Expected attribute '#{attr}' to equal '#{attr}'"
    end
  end

  test "#to_attributes removes boolean attributes when false" do
    attributes = FoxTail::HtmlAttributes.new(boolean_attributes.index_with(false)).to_attributes

    boolean_attributes.each do |attr|
      assert_not attributes.key?(attr), "Expected attribute '#{attr}' to be missing"
    end
  end

  test "#to_attributes converts to HTML attributes hash" do
    attributes = FoxTail::HtmlAttributes.new(
      class: "mb-2 text-primary-500 dark:text-primary-600",
      data: {
        controller: "fox-tail--popover",
        actions: "hover->fox-tail--popover#show",
        foo: :bar
      },
      aria: {
        visible: true
      },
      type: :checkbox,
      checked: true
    )

    assert_equal(
      {
        "class" => "mb-2 text-primary-500 dark:text-primary-600",
        "data-controller" => "fox-tail--popover",
        "data-actions" => "hover->fox-tail--popover#show",
        "data-foo" => "bar",
        "aria-visible" => "true",
        "type" => "checkbox",
        "checked" => "checked"
      },
      attributes.to_attributes
    )
  end

  test "#merge" do
    original = FoxTail::HtmlAttributes.new(
      class: "mb-2 text-primary-500 dark:text-primary-600",
      data: {
        controller: "fox-tail--popover",
        action: "hover->fox-tail--popover#show",
        foo: :bar
      },
      aria: {
        visible: true
      },
      type: :password
    )

    merged = original.merge(
      class: "mb-4 mt-3",
      data: {
        controller: "fox-tail--form-input",
        fox_tail__form_input_foo_value: :bar,
        action: "fox-tail--popover:show->fox-tail--form-input#visible",
        foo: :no_bar
      },
      aria: {
        visible: false
      }
    )

    assert_equal(
      {
        "class" => "text-primary-500 dark:text-primary-600 mb-4 mt-3",
        "data" => {
          "controller" => "fox-tail--popover fox-tail--form-input",
          "action" => "hover->fox-tail--popover#show fox-tail--popover:show->fox-tail--form-input#visible",
          "foo" => :no_bar,
          "fox_tail__form_input_foo_value" => :bar
        },
        "aria" => {
          "visible" => false
        },
        "type" => :password
      },
      merged
    )
  end
end
