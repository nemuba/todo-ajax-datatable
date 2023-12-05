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
//= require rails-ujs
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
});

