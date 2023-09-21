# frozen_string_literal: true

class Flowbite::ButtonComponent < Flowbite::ButtonBaseComponent
  renders_one :loading_icon, lambda { |options = {}| loader_svg_component options }
  renders_one :loading_label

  renders_one :left_visual, types: {
    icon: {
      as: :left_icon,
      renders: lambda { |icon, options = {}| icon_component :left, icon, options }
    },
    svg: {
      as: :left_svg,
      renders: lambda { |path, options = {}| svg_component :left, path, options }
    },
    image: {
      as: :left_image,
      renders: lambda { |path, options = {}| image_component :left, path, options }
    }
  }

  renders_one :right_visual, types: {
    icon: {
      as: :right_icon,
      renders: lambda { |icon, options = {}| icon_component :right, icon, options }
    },
    svg: {
      as: :right_svg,
      renders: lambda { |path, options = {}| svg_component :right, path, options }
    },
    image: {
      as: :right_image,
      renders: lambda { |path, options = {}| image_component :right, path, options }
    }
  }

  def loadable?
    loading? || super
  end

  def visuals?
    loadable? || left_visual? || right_visual?
  end

  def before_render
    super

    with_loading_icon if !loading_icon? && loadable?
  end

  def call
    super do
      concat loading_icon if loading_icon?
      concat left_visual if left_visual?

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
        concat retrieve_content
      end

      concat right_visual if right_visual?
    end
  end

  protected

  def root_classes
    super { loading? && theme.apply("root/disabled", self) }
  end

  def loading_svg_path
    Flowbite::ViewComponents.root.join "app/assets/vendor/flowbite-spinner.svg"
  end

  def loader_classes(additional_classes = nil)
    classnames theme.apply(:visual, self, { position: :left, loader: true }),
               controlled? && !loading? && theme.classname("hidden"),
               additional_classes
  end

  def visual_classes(side, addition_classes = nil)
    classnames theme.apply(:visual, self, { position: side }), addition_classes
  end

  private

  def loader_svg_component(options = {})
    path = options.delete(:path).presence || loading_svg_path
    options[:class] = loader_classes options[:class]
    options[:"aria-hidden"] = true
    options[stimulus_controller.target_key(raw: true)] = "loading" if controlled?
    Flowbite::InlineSvgComponent.new path, options
  end

  def icon_component(side, icon, options)
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = visual_classes side, options[:class]
    options[stimulus_controller.target_key(raw: true)] = "active" if controlled?
    Flowbite::IconBaseComponent.new icon, options
  end

  def svg_component(side, path, options)
    options[:"aria-hidden"] = true
    options[:class] = visual_classes side, options[:class]
    options[stimulus_controller.target_key(raw: true)] = "active" if controlled?
    Flowbite::InlineSvgComponent.new path, options
  end

  def image_component(side, path, options)
    options[:aria] ||= {}
    options[:aria][:hidden] = true
    options[:class] = visual_classes side, options[:class]
    options[:data] ||= {}
    options[:data][stimulus_controller.target_key] = "active" if controlled?

    image_tag path, options
  end
end
