// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require datatables
//= require jquery_ujs
//= require cocoon
//= require_tree .

$(document).on('turbolinks:load', function () {
  const App = window.App || {};

  App.renderModal = (partial) => {
    $('#new_todo').html('');
    $('#new_todo').append(partial);
    $('#modal').modal('show');
  }

  App.closeModal = () => {
    $('#modal').modal('hide');
    $('#new_todo').html('');
  }

  App.refreshDataTableAjax = () => {
    $('#todos').DataTable().ajax.reload();
  }

  App.refreshTotalItems = () => {
    $('#items-count').text('Items: ' + $('#items > .nested-fields').not(':hidden').length);
  }

  App.cocoonItems = () => {
    $('#items').on('cocoon:after-insert', function () {
      App.refreshTotalItems()
    });

    $('#items').on('cocoon:after-remove', function () {
      App.refreshTotalItems()
    });
  }

  App.Todo = {
    destroy: (e) => {
      Swal.fire({
        title: 'Remover Todo',
        text: "Voce tem certeza que deseja remover este Todo?",
        icon: 'warning',
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
    }
  }



  // DataTable
  var table = $('#todos').DataTable({
    dom: 'Bfrtip',
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
      loadingRecords: "carregando...",
      processing: "Processando...",
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
    $(this).html('<input type="text" placeholder="' + title + '" data-index="' + i + '" />');
  });

  // Filter event handler
  $(table.table().container()).on('keyup', 'tfoot input', function () {
    table
      .column($(this).data('index'))
      .search(this.value)
      .draw();
  });
});
