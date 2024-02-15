# frozen_string_literal: true

# @component FoxTail::FilterSummaryComponent
# @logical_path navigation
class FilterSummaryPreview < ViewComponent::Preview
  # @param q text Keyword search
  # @param states text States (comma seperated)
  # @param size select { choices: [base,sm] }
  # @param color text
  # @param clear_style select { choices: [link,button] }
  def playground(q: "", states: "", size: "base", color: "default", clear_style: "link")
    states = (states.presence || "").split(",").compact_blank.map(&:titleize)

    render FoxTail::FilterSummaryComponent.new(size: size, color: color) do |summary|
      summary.with_filter(:q).with_content("Keyword: <strong>#{q}</strong>".html_safe) if q.present?
      summary.with_filter(:states) { "State: <strong>#{states.to_sentence(two_words_connector: ' or ', last_word_connector: ', or')}".html_safe } if states.present?

      if clear_style == "link"
        summary.with_clear_link_content("Clear")
      else
        summary.with_clear_button_content("Clear")
      end
    end
  end
end
