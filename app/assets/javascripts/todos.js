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
      Swal.fire({
        title: 'Remover Todo',
        text: "Voce tem certeza que deseja remover este Todo?",
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Sim, delete!',
        cancelButtonText: 'Cancelar',
      }).then((result) => {
        if (result.value) {
          $.ajax({
            url: e.dataset.source,
            method: e.dataset.method,
            success: function (response) {
            }
          });
        }
      })
    },
    delete_all: (url, ids) => {
      if (ids.length == 0) {
        Swal.fire({
          icon: 'warning',
          title: 'Oops...',
          text: 'Nenhum registro selecionado!',
        })
        return;
      }

      Swal.fire({
        title: 'Você tem certeza?',
        text: "Você não poderá reverter isso!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sim, delete!',
        cancelButtonText: 'Cancelar'
      }).then((result) => {
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
      })
    },
    renderModal: (title, partial) => {
      $('#modal-title').html(title);
      $('#modal-body').html(partial);
      $('#modal').modal('show');
    },
    closeModal: () => {
      $('#modal-title').html('');
      $('#modal-body').html('');
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
    }
  }

  window.App = App;

  var table = $('#todos').DataTable({
    fixedHeader: true,
    processing: true,
    serverSide: true,
    pageLength: 5,
    pagingType: 'first_last_numbers',
    ajax: { url: $('#todos').data('source') },
    buttons: [
      { extend: 'reload', className: 'btn btn-primary' },
      { extend: 'print', className: 'btn btn-primary' },
      { extend: 'export_csv', className: 'btn btn-primary' },
      { extend: 'export_pdf', className: 'btn btn-primary' },
      { extend: 'export_docx', className: 'btn btn-primary' },
      { extend: 'export_xlsx', className: 'btn btn-primary' },
      { extend: 'select_all', className: 'btn btn-primary' },
      { extend: 'delete_all', className: 'btn btn-danger' },
    ],
    columns: [
      { title: '#', data: 'id' },
      { title: 'Título', data: 'title' },
      { title: 'Descrição', data: 'description' },
      { title: 'Status', data: 'done' },
      { title: 'Items', data: 'items' },
      { title: 'Criado em', data: 'created_at' },
      { title: 'Atualizado em', data: 'updated_at' },
      { title: 'Ações', data: "actions" }
    ],
    select: true,
    order: [[0, 'desc']],
    columnDefs: [
      { orderable: false, targets: [4, 7] },
      { searchable: false, targets: [4, 7] },
      { className: 'text-center', targets: [0, 3, 4, 5, 6, 7] }
    ],
    language: {
      search: 'Pesquisar:',
      zeroRecords: 'Nenhum registro encontrado',
      dom: '<"pull-left"f><"pull-right"l>tip',
      decimal: "",
      emptyTable: "Nenhum registro encontrado",
      info: "Mostrando de _START_ até _END_ de _TOTAL_ registros",
      infoEmpty: "Mostrando 0 até 0 de 0 registros",
      infoFiltered: "(Filtrados de _MAX_ registros)",
      infoPostFix: "",
      thousands: ".",
      lengthMenu: "Mostrar _MENU_ Registros",
      loadingRecords: "Carregando...",
      processing: "Processando...",
      select: {
        rows: {
          _: "Selecionado %d linhas",
          0: "Nenhuma linha selecionada",
          1: "Selecionado 1 linha"
        }
      },
      aria: {
        sortAscending: ': ative para ordenar a coluna em ordem crescente',
        sortDescending: ': ative para ordenar a coluna em ordem decrescente',
      },
      paginate: {
        first: 'Primeiro',
        last: 'Último',
        next: 'Próximo',
        previous: 'Anterior',
      }
    },
  });

  // Setup - add a text input to each footer cell
  $('#todos tfoot th').each(function (i) {
    var title = $('#todos thead th').eq($(this).index()).text();

    if (!['#', 'Ações', 'Items'].includes(title)) {
      $(this).html('<input class="form-control" type="search" placeholder="' + title + '" data-index="' + i + '" />');
    } else {
      $(this).html('<span class="text-white" data-index="' + i + '"></span>');
    }
  });

  // Filter event handler
  $(table.table().container()).on('keyup', 'tfoot input', function () {
    table
      .column($(this).data('index'))
      .search(this.value)
      .draw();
  });
});
