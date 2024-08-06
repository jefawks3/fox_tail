# frozen_string_literal: true

class FoxTail::ShowPasswordComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  has_option :for, as: :input_id

  def input_id
    options[:input_id] ||= tag_id
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    render FoxTail::PasswordInputTriggerComponent.new("##{input_id}", html_attributes) do |trigger|
      content_tag :button, trigger.html_attributes.merge(type: :button) do
        concat render_content(:hidden, text(:show), :eye)
        concat render_content(:visible, text(:hide), :eye_slash)
      end
    end
  end

  private

  def text(key)
    t key, scope: "helpers.show_password", default: key.to_s.humanize
  end

  def render_content(state, text, icon)
    classes = classnames theme.apply(:container, self), theme.apply("container/#{state}", self)

    content_tag :div, class:  classes do
      concat render(FoxTail::IconBaseComponent.new(icon, class: theme.apply(:icon, self), 'aria-hidden': true))
      concat content_tag(:span, text)
    end
  end
end
