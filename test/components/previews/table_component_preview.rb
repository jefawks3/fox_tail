# frozen_string_literal: true

# @logical_path components
# @component FoxTail::TableComponent
class TableComponentPreview < ViewComponent::Preview

  def default
    render FoxTail::TableComponent.new do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  # @!group Highlight

  def stripped_rows
    render FoxTail::TableComponent.new highlight: :rows do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  def stripped_columns
    render FoxTail::TableComponent.new highlight: :columns do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  def hover
    render FoxTail::TableComponent.new hover: true do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  # @!endgroup

  # @!group Layouts

  def table_footer
    render FoxTail::TableComponent.new hover: true do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Quantity"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "1"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "1"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "1"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "1"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "1"
        r.with_column_content "$999"
      end
      t.with_footer do |f|
        f.with_column(tag: :th).with_content("Total")
        f.with_column_content "5"
        f.with_column_content "$6,895"
      end
    end
  end

  def table_caption
    render FoxTail::TableComponent.new do |t|
      t.with_caption do
        <<~HTML.html_safe
           Our Products
           <p class="mt-1 text-sm font-normal text-gray-500 dark:text-gray-400">
              Browse a list of Flowbite products designed to help you work and play, stay organized, get answers,
              keep in touch, grow your business, and more.
          </p>
        HTML
      end
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  # @!endgroup

  # @!group Border

  def bordered
    render FoxTail::TableComponent.new border: true do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  def borderless
    render FoxTail::TableComponent.new border: false do |t|
      t.with_header do |h|
        h.with_column_content "Product Name"
        h.with_column_content "Color"
        h.with_column_content "Category"
        h.with_column_content "Price"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple MacBook Pro 17\"")
        r.with_column_content "Silver"
        r.with_column_content "Laptop"
        r.with_column_content "$2999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Microsoft Surface Pro")
        r.with_column_content "White"
        r.with_column_content "Laptop PC"
        r.with_column_content "$1999"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Magic Mouse 2")
        r.with_column_content "Black"
        r.with_column_content "Accessories"
        r.with_column_content "$99"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Google Pixel Phone")
        r.with_column_content "Gray"
        r.with_column_content "Phone"
        r.with_column_content "$799"
      end
      t.with_row do |r|
        r.with_column(tag: :th).with_content("Apple Watch")
        r.with_column_content "Red"
        r.with_column_content "Wearables"
        r.with_column_content "$999"
      end
    end
  end

  # @!endgroup
end
