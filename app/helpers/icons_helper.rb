# frozen_string_literal: true

module IconsHelper
  def icon_regular(color = 'text-black', &block)
    "<i class='fa-regular #{block.call} #{color}'></i>".html_safe
  end

  def icon_solid(color = 'text-white', &block)
    "<i class='fa-solid #{block.call} #{color}'></i>".html_safe
  end
end
