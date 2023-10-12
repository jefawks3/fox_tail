# frozen_string_literal: true

# @logical_path components
# @component FoxTail::CarouselComponent
class CarouselComponentPreview < ViewComponent::Preview

  # @param interval number
  # @param controls toggle
  # @param indicators toggle
  def playground(interval: 3000, controls: true, indicators: true)
    render FoxTail::CarouselComponent.new(interval: interval, controls: controls, indicators: indicators) do |t|
      (0..5).each do |i|
        t.with_slide do
          t.image_tag "https://picsum.photos/1200/400?_s=#{i}", class: "absolute w-full h-full object-cover"
        end
      end
    end
  end

  def default
    render FoxTail::CarouselComponent.new do |t|
      (0..5).each do |i|
        t.with_slide do
          t.image_tag "https://picsum.photos/1200/400?_s=#{i}", class: "absolute w-full h-full object-cover"
        end
      end
    end
  end

  def static
    render FoxTail::CarouselComponent.new interval: 0 do |t|
      (0..5).each do |i|
        t.with_slide do
          t.image_tag "https://picsum.photos/1200/400?_s=#{i}", class: "absolute w-full h-full object-cover"
        end
      end
    end
  end

  def hide_controls
    render FoxTail::CarouselComponent.new controls: false do |t|
      (0..5).each do |i|
        t.with_slide do
          t.image_tag "https://picsum.photos/1200/400?_s=#{i}", class: "absolute w-full h-full object-cover"
        end
      end
    end
  end

  def hide_indicators
    render FoxTail::CarouselComponent.new indicators: false do |t|
      (0..5).each do |i|
        t.with_slide do
          t.image_tag "https://picsum.photos/1200/400?_s=#{i}", class: "absolute w-full h-full object-cover"
        end
      end
    end
  end
end
