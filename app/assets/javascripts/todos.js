$(document).on('turbolinks:load', function () {
  const App = window.App || {};

  App.Modal = Modal.init();
  App.Todo = {
    destroy: (e) => {
      Alert.confirm(
        'Remover Todo',
        'Você tem certeza que deseja remover este Todo?'
      ).then((result) => {
        if (result.value) {
          $.ajax({
            url: e.dataset.source,
            method: e.dataset.method,
            success: function (response) {
            }
          });
        }
      });
    },
    delete_all: (url, ids) => {
      if (ids.length == 0) {
        Alert.warning('Oops...', 'Nenhum registro selecionado!');
        return;
      }

      Alert.confirm(
        'Você tem certeza?',
        'Você não poderá reverter isso!'
      ).then((result) => {
        if (result.isConfirmed) {
          $.ajax({
            url: url,
            type: 'DELETE',
            data: { ids: ids },
            success: function (data) {
              App.Todo.refreshDataTableAjax();
            }
          });
        }
      });
    },
    refreshDataTableAjax: () => {
      $('#todos').DataTable().ajax.reload();
      $('.select-all').removeClass('btn-secondary');
    },
    refreshTotalItems: () => {
      $('#items-count').text('Items: ' + $('#items > .nested-fields').not(':hidden').length);
    },
    cocoonItems: () => {
      $('#items').on('cocoon:after-insert', function () {
        App.Todo.refreshTotalItems()
      });

      $('#items').on('cocoon:after-remove', function () {
        App.Todo.refreshTotalItems()
      });
    },
    import: (form, self) => {
      $.ajax({
        url: form.attr('action'),
        type: form.attr('method'),
        data: new FormData(self),
        dataType: 'script',
        processData: false,
        contentType: false,
        success: function (data) {
          form[0].reset();
          $('input[type="submit"]').prop('disabled', false);
        }
      });
    },
    load_table: () => {
      Datatable.init('todos');
    }
  }

  window.App = App;
});
