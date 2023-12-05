# frozen_string_literal: true

# TodoDecorator
class TodoDecorator < ApplicationDecorator
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def created_at
    h.content_tag :span, class: 'time' do
      object.created_at.strftime('%d/%m/%y')
    end
  end

  def updated_at
    h.content_tag :span, class: 'time' do
      object.updated_at.strftime('%d/%m/%y')
    end
  end

  def dt_actions
    links = []
    links << h.link_to('Visualizar', h.todo_path(object), remote: true, class: 'btn btn-sm btn-primary').html_safe
    links << h.link_to('Editar', h.edit_todo_path(object), remote: true, class: 'btn btn-sm btn-success').html_safe
    links << h.link_to('Excluir', h.todo_path(object), method: :delete, remote: true,
                                                       data: { confirm: 'Are you sure?' },
                                                       class: 'btn btn-sm btn-danger').html_safe
    links.join(' ').html_safe
  end
end
