# frozen_string_literal: true

module IconsHelper
  def icon_regular(color = 'text-black', &block)
    content_tag(:i, nil, class: "fa-regular #{block.call} #{color}")
  end

  def icon_solid(color = 'text-white', &block)
    content_tag(:i, nil, class: "fa-solid #{block.call} #{color}")
  end
end
