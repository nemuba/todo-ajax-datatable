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
    [btn_show, btn_edit, btn_destroy].join(' ').html_safe
  end

  private

  def btn_show
    h.link_to(h.icon_solid { 'fa-search' }, h.todo_path(object), remote: true, class: 'btn btn-sm btn-primary').html_safe
  end

  def btn_edit
    h.link_to(h.icon_solid { 'fa-pencil' }, h.edit_todo_path(object), remote: true, class: 'btn btn-sm btn-success').html_safe
  end

  def btn_destroy
    h.button_tag(h.icon_solid { 'fa-trash' }, class: 'btn btn-sm btn-danger', onClick: 'App.Todo.destroy(this)', data: { method: :delete, source: h.todo_path(object)}).html_safe
  end
end
