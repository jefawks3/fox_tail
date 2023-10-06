# frozen_string_literal: true

# @label FAB
# @logical_path components
class FABComponentPreview < ViewComponent::Preview

  def tooltip_labels
    render FoxTail::FABComponent.new do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def inside_labels
    render FoxTail::FABComponent.new label_style: :inside do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def outside_labels
    render FoxTail::FABComponent.new label_style: :outside do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def bottom_right
    render FoxTail::FABComponent.new placement: :bottom_right do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def bottom_right_horizontal
    render FoxTail::FABComponent.new placement: :bottom_right, item_placement: :left do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def bottom_left
    render FoxTail::FABComponent.new placement: :bottom_left do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def bottom_left_horizontal
    render FoxTail::FABComponent.new placement: :bottom_left, item_placement: :right do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def top_right
    render FoxTail::FABComponent.new placement: :top_right do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def top_right_horizontal
    render FoxTail::FABComponent.new placement: :top_right, item_placement: :left do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def top_left
    render FoxTail::FABComponent.new placement: :top_left do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def top_left_horizontal
    render FoxTail::FABComponent.new placement: :top_left, item_placement: :right do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def custom_fab
    render FoxTail::FABComponent.new do |f|
      f.with_icon("plus", class: "transition-transform group-[.show]/fab:rotate-45")
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def hover_trigger
    render FoxTail::FABComponent.new trigger_type: :hover do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end

  def click_trigger
    render FoxTail::FABComponent.new trigger_type: :click do |f|
      f.with_item("share").with_content("Share")
      f.with_item("printer").with_content("Print")
      f.with_item("arrow-down-tray").with_content("Download")
      f.with_item("document-duplicate").with_content("Copy")
    end
  end
end
