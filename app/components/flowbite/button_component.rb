# frozen_string_literal: true

class Flowbite::ButtonComponent < Flowbite::ButtonBaseComponent
  renders_one :loading_icon, lambda { |options = {}| render_loader options }
  renders_one :loading_label
  renders_one :left_icon, lambda { |icon, options = {}| render_icon icon, options, :left }
  renders_one :right_icon, lambda { |icon, options = {}| render_icon icon, options, :right }

  def loadable?
    loading? || !!options[:loadable]
  end

  def visuals?
    loadable? || left_icon? || right_icon?
  end

  def call
    super do
      concat(loading_icon? ? loading_icon : render(render_loader)) if loadable?
      concat left_icon if left_icon?

      if loadable? && loading_label?
        if controlled?
          concat(
            content_tag(
              :span,
              loading_label,
              class: !loading? && theme.classname("hidden"),
              data: { stimulus_controller.target_key => "loading" }
            )
          )
          concat(
            content_tag(
              :span,
              content,
              class: loading? && theme.classname("hidden"),
              data: { stimulus_controller.target_key => "active" }
            )
          )
        else
          concat loading_label
        end
      else
        concat content
      end

      concat right_icon if right_icon?
    end
  end

  protected

  def root_classes
    super { loading? && theme.apply("root/disabled", self) }
  end

  private

  def render_loader(options = {})
    svg = Flowbite::ViewComponents.root.join("app/assets/vendor/flowbite-spinner.svg")
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:visual, self),
                                 theme.apply("visual/left", self),
                                 theme.apply("visual/loader", self),
                                 controlled? && !loading? && theme.classname("hidden"),
                                 options[:class]

    options[stimulus_controller.target_key(raw: true)] = "loading" if controlled?
    Flowbite::InlineSvgComponent.new svg, **options
  end

  def render_icon(icon, options, side)
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:visual, self),
                                 theme.apply("visual/#{side}", self),
                                 options[:class]

    options[stimulus_controller.target_key(raw: true)] = "active" if controlled?
    Flowbite::IconBaseComponent.new icon, **options
  end
end
