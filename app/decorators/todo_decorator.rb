# frozen_string_literal: true

# TodoDecorator
class TodoDecorator < ApplicationDecorator
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def created_at
    self.object.created_at.strftime('%d/%m/%Y')
  end

  def updated_at
    self.object.updated_at.strftime('%d/%m/%Y')
  end

  def dt_actions
    [btn_show, btn_edit, btn_destroy].join(' ').html_safe
  end

  private

  def btn_show
    h.link_to('<i class="fa-solid fa-search"></i>'.html_safe, h.todo_path(object), remote: true, class: 'btn btn-sm btn-primary').html_safe
  end

  def btn_edit
    h.link_to('<i class="fa-solid fa-pencil"></i>'.html_safe, h.edit_todo_path(object), remote: true, class: 'btn btn-sm btn-success').html_safe
  end

  def btn_destroy
     h.button_tag('<i class="fa-solid fa-trash"></i>'.html_safe, class: 'btn btn-sm btn-danger', onClick: 'App.Todo.destroy(this)' ,data: { method: :delete, source: h.todo_path(object)}).html_safe
  end
end
