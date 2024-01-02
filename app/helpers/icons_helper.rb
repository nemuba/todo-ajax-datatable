# frozen_string_literal: true

module IconsHelper
  def icon_regular
    "<i class='fa-regular #{yield}'></i>".html_safe
  end

  def icon_solid
    "<i class='fa-solid #{yield}'></i>".html_safe
  end
end
