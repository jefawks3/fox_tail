# frozen_string_literal: true

# @component FoxTail::AvatarStackComponent
# @logical_path components
class AvatarStackComponentPreview < ViewComponent::Preview
  # @!group Sizes

  # @label Extra Small
  def xs
    render(FoxTail::AvatarStackComponent.new(size: :xs)) do |c|
      c.with_avatar src: "users/bonnie-green.png"
      c.with_avatar src: "users/jese-leos.png"
      c.with_avatar icon: :user
      c.with_avatar src: "users/robert-brown.png"
      c.with_avatar text: "TT"
      c.with_counter "+99", url: "#"
    end
  end

  # @label Small
  def sm
    render(FoxTail::AvatarStackComponent.new(size: :sm)) do |c|
      c.with_avatar src: "users/bonnie-green.png"
      c.with_avatar src: "users/jese-leos.png"
      c.with_avatar icon: :user
      c.with_avatar src: "users/robert-brown.png"
      c.with_avatar text: "TT"
      c.with_counter "+99", url: "#"
    end
  end

  # @label Base (Default)
  def base
    render(FoxTail::AvatarStackComponent.new(size: :base)) do |c|
      c.with_avatar src: "users/bonnie-green.png"
      c.with_avatar src: "users/jese-leos.png"
      c.with_avatar icon: :user
      c.with_avatar src: "users/robert-brown.png"
      c.with_avatar text: "TT"
      c.with_counter "+99", url: "#"
    end
  end

  # @label Large
  def lg
    render(FoxTail::AvatarStackComponent.new(size: :lg)) do |c|
      c.with_avatar src: "users/bonnie-green.png"
      c.with_avatar src: "users/jese-leos.png"
      c.with_avatar icon: :user
      c.with_avatar src: "users/robert-brown.png"
      c.with_avatar text: "TT"
      c.with_counter "+99", url: "#"
    end
  end

  # @label Extra Large
  def xl
    render(FoxTail::AvatarStackComponent.new(size: :xl)) do |c|
      c.with_avatar src: "users/bonnie-green.png"
      c.with_avatar src: "users/jese-leos.png"
      c.with_avatar icon: :user
      c.with_avatar src: "users/robert-brown.png"
      c.with_avatar text: "TT"
      c.with_counter "+99", url: "#"
    end
  end

  # @!endgroup
end
