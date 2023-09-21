# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::SelectComponent
# @component Flowbite::Select::OptionComponent
# @component Flowbite::Select::GroupOptionComponent
class SelectComponentPreview < ViewComponent::Preview
  # @param size select {choices: [sm,base,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param multiple toggle
  # @param disabled toggle
  def playground(size: :base, state: :default, multiple: false, disabled: false)
    render Flowbite::SelectComponent.new(size: size, state: state, disabled: disabled, multiple: multiple) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @!group Disabled

  def active
    render Flowbite::SelectComponent.new(disabled: false) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  def disabled
    render Flowbite::SelectComponent.new(disabled: true) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::SelectComponent.new(size: :sm) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @label Base (Default)
  def base
    render Flowbite::SelectComponent.new(size: :base) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  def large
    render Flowbite::SelectComponent.new(size: :lg) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @!endgroup

  # @!group Multiple

  def single
    render Flowbite::SelectComponent.new(multiple: false) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  def multiple
    render Flowbite::SelectComponent.new(multiple: true, name: :multiple) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @!endgroup

  # @!group States

  def default
    render Flowbite::SelectComponent.new(state: :default) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  def valid
    render Flowbite::SelectComponent.new(state: :valid) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  def invalid
    render Flowbite::SelectComponent.new(state: :invalid) do |c|
      c.with_select_option "No Country", value: ""
      c.with_select_group "North America" do |g|
        g.with_group_option "United States", value: "US", selected: true
        g.with_group_option "Canada"
      end
      c.with_select_group "Europe" do |g|
        g.with_group_option "Denmark"
        g.with_group_option "Germany"
        g.with_group_option "France"
      end
    end
  end

  # @!endgroup

  # @!group Custom Content

  def choices
    render Flowbite::SelectComponent.new(choices: %w[SP EN FR], value: "EN")
  end

  def grouped_choices
    render Flowbite::SelectComponent.new(
      choices: [["North America", ["United States", "Canada"]], ["Europe", %w[Denmark Germany France]]],
      value: "United States"
    )
  end

  def custom_content
    render Flowbite::SelectComponent.new do |select|
      select.send(:view_context).options_for_select %w[SP EN FR], selected: "EN", disabled: select.disabled?
    end
  end

  # @!endgroup
end
