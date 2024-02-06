# frozen_string_literal: true

# @component FoxTail::AccordionComponent
# @component FoxTail::Accordion::ItemComponent
# @logical_path components
class AccordionComponentPreview < ViewComponent::Preview

  # @param flush toggle "Remove background color & rounded borders"
  # @param always_open toggle "Keep items open"
  # @param icon "Heroicon to display to the left of the text"
  # @param arrow "Heroicon to display to the right of the text"
  # @param rotate_arrow toggle "Rotate the arrow when collapsed"
  def playground(flush: false, always_open: false, icon: :question_mark_circle, arrow: :chevron_down, rotate_arrow: true)
    render FoxTail::AccordionComponent.new(always_open: always_open, flush: flush) do |accordion|
      0.upto(3) do |i|
        accordion.with_item Faker::Lorem.question, open: i.zero? do |item|
          item.with_icon icon if icon.present?
          item.with_arrow(icon: arrow, rotate: rotate_arrow) if arrow.present?
          Faker::Lorem.paragraph sentence_count: 10
        end
      end
    end
  end

  def flush
    render FoxTail::AccordionComponent.new(flush: true) do |accordion|
      0.upto(3) do |i|
        accordion.with_item Faker::Lorem.question, open: i.zero? do |item|
          item.with_arrow
          Faker::Lorem.paragraph sentence_count: 10
        end
      end
    end
  end

  def always_open
    render FoxTail::AccordionComponent.new(always_open: true) do |accordion|
      0.upto(3) do |i|
        accordion.with_item Faker::Lorem.question, open: i.zero? do |item|
          item.with_arrow
          Faker::Lorem.paragraph sentence_count: 10
        end
      end
    end
  end
end
