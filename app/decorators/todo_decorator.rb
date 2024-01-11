# frozen_string_literal: true

# TodoDecorator
class TodoDecorator < ApplicationDecorator
  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def updated_at
    object.updated_at.strftime('%d/%m/%Y')
  end

  def dt_actions
    [btn_clone, btn_show, btn_edit, btn_destroy].join(' ').html_safe
  end

  private

  def btn_show
    h.link_to(
      h.icon_solid { 'fa-search' },
      h.todo_path(object),
      remote: true,
      class: 'btn btn-sm btn-primary',
      data: { toggle: 'tooltip', placement: 'top' },
      title: 'Visualizar'
    ).html_safe
  end

  def btn_edit
    h.link_to(
      h.icon_solid { 'fa-pencil' },
      h.edit_todo_path(object),
      remote: true,
      class: 'btn btn-sm btn-success',
      data: { toggle: 'tooltip', placement: 'top' },
      title: 'Editar'
    ).html_safe
  end

  def btn_destroy
    h.button_tag(
      h.icon_solid { 'fa-trash' },
      class: 'btn btn-sm btn-danger',
      onClick: 'App.Todo.destroy(this)',
      data: { method: :delete, source: h.todo_path(object), toggle: 'tooltip', placement: 'top'},
      title: 'Excluir'
    ).html_safe
  end

  def btn_clone
    h.link_to(
      h.icon_solid { 'fa-refresh' },
      h.clone_todo_path(object),
      remote: true,
      class: 'btn btn-sm btn-info',
      data: { toggle: 'tooltip', placement: 'top' },
      title: 'Clonar'
    ).html_safe
  end
end
