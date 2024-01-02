
App.import_channel = App.cable.subscriptions.create("ImportChannel", {
  connected: function () {
    console.log('Conectado ao canal de importação')
  },

  disconnected: function () {
    console.log('Desconectado do canal de importação')
  },

  received: function (data) {
    Toast.success(data.message);
    App.Todo.refreshDataTableAjax()
  }
});
