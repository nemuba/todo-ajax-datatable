
App.delete_all_channel = App.cable.subscriptions.create("DeleteAllChannel", {
  connected: function () {
    console.log("Conectado ao canal de exclusão em lote")
  },

  disconnected: function () {
    console.log("Desconectado ao canal de exclusão em lote")
  },

  received: function (data) {
    Toast[data.type](data.message)
    App.Todo.refreshDataTableAjax()
  }
});
