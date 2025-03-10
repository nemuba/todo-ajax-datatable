$(document).on('turbolinks:load', function () {
  const App = window.App || {};

  App.Todo = {
    validation: () => {
      $('#modal .form-control').filter(function () {
        return ($(this).val() == '');
      }).first().focus();
      $('#modal .form-control').each(function () {
        if ($(this).val() == '') {
          $(this).addClass('is-invalid');
        } else {
          $(this).removeClass('is-invalid');
        }
      });
    },
    render_errors: (partial) => {
      $('#modal #todo_errors').html('');
      $('#modal #todo_errors').append(partial);
      App.Todo.validation();
    },
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
    renderModal: (title, partial) => {
      $('#modal').modal('show');
      $('#modal #modal-title').html(title);
      $('#modal #content').html('');
      $(partial).appendTo('#modal #content');
    },
    closeModal: () => {
      $('#modal #modal-title').html('');
      $('#modal #content').html('');
      $('#modal').modal('hide');
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
