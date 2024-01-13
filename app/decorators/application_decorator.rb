# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end
  delegate_all

  def to_format(date, format)
    date.strftime(format)
  rescue StandardError => e
    date.to_s unless date.present?
  end

  def link(link:, title:, icon:, remote: true, class_name:)
    h.link_to(
      h.icon_solid { icon },
      link,
      remote: remote,
      class: class_name,
      data: { toggle: 'tooltip', placement: 'top' },
      title: title
    ).html_safe
  end

  def button(link:, title:, icon:, remote: true, class_name:, onClick:)
    h.button_tag(
      h.icon_solid { icon },
      class: class_name,
      onClick: onClick,
      data: { method: :delete, source: link, toggle: 'tooltip', placement: 'top'},
      title: title
    ).html_safe
  end

  def link_show(link:, title:, icon:, remote: true)
    link(link: link, title: title, icon: icon, remote: remote, class_name: 'btn btn-sm btn-primary')
  end

  def link_edit(link:, title:, icon:, remote: true)
    link(link: link, title: title, icon: icon, remote: remote, class_name: 'btn btn-sm btn-success')
  end

  def link_destroy(link:, title:, icon:, onClick:)
    button(link: link, title: title, icon: icon, remote: true, class_name: 'btn btn-sm btn-danger', onClick: onClick)
  end

  def link_clone(link:, title:, icon:, remote: true)
    link(link: link, title: title, icon: icon, remote: remote, class_name: 'btn btn-sm btn-info')
  end
end
