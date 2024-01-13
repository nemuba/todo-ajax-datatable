# frozen_string_literal: true

require 'active_support/concern'

module ExportDocument
  extend ActiveSupport::Concern

  def template_render(format_type, locals = {}, template = 'todos/pdf.html.erb')
    render_to_string(
      **format_type,
      template: template,
      layout: 'pdf.html.erb',
      locals: locals,
      orientation: 'Landscape',
      encoding: 'UTF-8'
    )
  end
end
