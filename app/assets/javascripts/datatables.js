//= require datatables/jquery.dataTables

// optional change '//' --> '//=' to enable

//= require datatables/extensions/AutoFill/dataTables.autoFill
//= require datatables/extensions/Buttons/dataTables.buttons
//= require datatables/extensions/Buttons/buttons.html5
//= require datatables/extensions/Buttons/buttons.print
//= require datatables/extensions/Buttons/buttons.colVis
//= require datatables/extensions/Buttons/buttons.flash
//= require datatables/extensions/ColReorder/dataTables.colReorder
//= require datatables/extensions/FixedColumns/dataTables.fixedColumns
//= require datatables/extensions/FixedHeader/dataTables.fixedHeader
//= require datatables/extensions/KeyTable/dataTables.keyTable
//= require datatables/extensions/Responsive/dataTables.responsive
//= require datatables/extensions/RowGroup/dataTables.rowGroup
//= require datatables/extensions/RowReorder/dataTables.rowReorder
//= require datatables/extensions/Scroller/dataTables.scroller
//= require datatables/extensions/Select/dataTables.select

//= require datatables/dataTables.bootstrap4
//= require datatables/extensions/AutoFill/autoFill.bootstrap4
//= require datatables/extensions/Buttons/buttons.bootstrap4
//= require datatables/extensions/Responsive/responsive.bootstrap4


//Global setting and initializer

$.extend($.fn.dataTable.defaults, {
  responsive: true,
  pagingType: 'full',
  //dom: "<'row'<'col-sm-4 text-left'f><'right-action col-sm-8 text-right'<'buttons'B> <'select-info'> >>" +
  //  "<'row'<'dttb col-12 px-0'tr>>" +
  //  "<'row'<'col-sm-12 table-footer'lip>>"
});


$(document).on('preInit.dt', function (e, settings) {
  var api, table_id, url;
  api = new $.fn.dataTable.Api(settings);
  table_id = "#" + api.table().node().id;
  url = $(table_id).data('source');
  if (url) {
    return api.ajax.url(url);
  }
});


// init on turbolinks load
$(document).on('turbolinks:load', function () {
  if (!$.fn.DataTable.isDataTable("table[id^=dttb-]")) {
    $("table[id^=dttb-]").DataTable();
  }
});

// turbolinks cache fix
$(document).on('turbolinks:before-cache', function () {
  var dataTable = $($.fn.dataTable.tables(true)).DataTable();
  if (dataTable !== null) {
    dataTable.clear();
    dataTable.destroy();
    return dataTable = null;
  }
});

$.fn.dataTable.ext.buttons.reload = {
  text: '<i class="fa-solid fa-rotate-right"></i>',
  attr: {
    class: 'btn btn-primary'
  },
  action: function (e, dt, node, config) {
    dt.ajax.reload();
  }
};

$.fn.dataTable.ext.buttons.print = {
  text: '<i class="fa-solid fa-print"></i>',
  attr: {
    class: 'btn btn-primary'
  },
  action: function (e, dt, node, config) {
    $('.dt-buttons').hide();
    $('#todos_filter').hide();
    $('a#new_todo').hide();
    $('#todos tfoot').hide();
    window.print();
    $('.dt-buttons').show();
    $('#todos_filter').show();
    $('a#new_todo').show();
    $('#todos tfoot').show();
  }
};

$.fn.dataTable.ext.buttons.export_csv = {
  text: 'CSV<i class="fa-solid fa-download"></i>',
  attr: {
    class: 'btn btn-primary'
  },
  action: function (e, dt, node, config) {
    var url = dt.ajax.url()
    url = url.replace('.json', '.csv')
    window.open(url)
  }
};

$.fn.dataTable.ext.buttons.export_pdf = {
  text: 'PDF<i class="fa-solid fa-download"></i>',
  attr: {
    class: 'btn btn-primary'
  },
  action: function (e, dt, node, config) {
    var url = dt.ajax.url()
    url = url.replace('.json', '.pdf')
    window.open(url)
  }
};

$.fn.dataTable.ext.buttons.select_all = {
  text: '<i class="fa-solid fa-check"></i>',
  attr: {
    class: 'btn btn-primary select-all'
  },
  action: function (e, dt, node, config) {
    if (dt.rows({ selected: true }).count() == dt.rows().count()) {
      dt.rows().deselect();
      $('.select-all').removeClass('btn-secondary');
    } else {
      dt.rows().select();
      $('.select-all').addClass('btn-secondary');
    }
  }
};


$.fn.dataTable.ext.buttons.delete_all = {
  text: 'Deletar em lote <i class="fa-solid fa-file"></i>',
  attr: {
    class: 'btn btn-danger'
  },
  action: function (e, dt, node, config) {
    var ids = dt.rows({ selected: true }).ids().toArray();
    if (ids.length == 0) {
      Swal.fire({
        icon: 'error',
        title: 'Oops...',
        text: 'Nenhum registro selecionado!'
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
        var url = dt.ajax.url()
        url = url.replace('.json', '/delete_all.js')
        $.ajax({
          url: url,
          type: 'DELETE',
          data: { ids: ids },
          success: function (data) {
            dt.ajax.reload();
            $('.select-all').removeClass('btn-secondary');
          }
        });
      }
    })
  }
};
