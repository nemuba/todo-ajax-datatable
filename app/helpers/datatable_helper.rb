# frozen_string_literal: true

module DatatableHelper
  def datatable_ajax(id:, url:, &block)
    render('shared/datatable', id: id, url: url) do
      capture(&block)
    end
  end
end
