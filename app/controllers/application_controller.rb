# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def render_data(format)
    send_data(template_render({ format => 'Todos' }, { todos: Todo.includes(:items).all }), filename: filename(format))
  end

  def filename(format_type)
    "todos_#{Time.zone.today}.#{format_type}"
  end
end
