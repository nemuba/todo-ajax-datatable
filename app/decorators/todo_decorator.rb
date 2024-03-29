# frozen_string_literal: true

# TodoDecorator
class TodoDecorator < ApplicationDecorator
  def done
    icon = object.done ? h.icon_solid { 'fa-check' } : h.icon_solid { 'fa-times' }

    h.content_tag(:span, icon, class: "badge badge-#{object.done ? 'success' : 'danger'} badge-pill")
  end

  def created_at
    to_format(object.created_at, '%d/%m/%Y')
  end

  def updated_at
    to_format(object.updated_at, '%d/%m/%Y')
  end

  def dt_actions
    h.content_tag(:div, class: 'btn-group') do
      [btn_clone, btn_show, btn_edit, btn_destroy].join(' ').html_safe
    end.html_safe
  end

  private

  def btn_show
    link_show(link: h.todo_path(object))
  end

  def btn_edit
    link_edit(link: h.edit_todo_path(object))
  end

  def btn_destroy
    link_destroy(link: h.todo_path(object), onClick: 'App.Todo.destroy(this)')
  end

  def btn_clone
    link_clone(link: h.clone_todo_path(object))
  end
end
