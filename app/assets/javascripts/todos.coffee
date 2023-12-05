# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('turbolinks:load').ready ->
    $('#todos').dataTable
      processing: true
      serverSide: true
      pageLength: 2
      pagingType: 'first_last_numbers'
      ajax:
        url: $('#todos').data('source')
      columns: [
        { title: '#', data: 'id' },
        { title: 'Título', data: 'title' },
        { title: 'Descrição', data: 'description' },
        { title: 'Status', data: 'done' },
        { title: 'Criado em', data: 'created_at' },
        { title: 'Atualizado em', data: 'updated_at' },
        { title: 'Ações', data: "actions" }
      ],
      order: [[ 2, 'desc' ]]
      language:
        search: 'Pesquisar:'
        zeroRecords: 'Nenhum registro encontrado'
        dom: '<"pull-left"f><"pull-right"l>tip'
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
        aria:
          sortAscending: ': ative para ordenar a coluna em ordem crescente'
          sortDescending: ': ative para ordenar a coluna em ordem decrescente'
        paginate:
          first: 'Primeiro'
          last: 'Último'
          next: 'Próximo'
          previous: 'Anterior'
