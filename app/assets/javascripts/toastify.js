
Toast = {
  fire: function (message, backgroundColor) {
    Toastify({
      text: message,
      duration: 3000,
      close: true,
      gravity: "top",
      position: "right",
      backgroundColor: backgroundColor,
      stopOnFocus: true,
    }).showToast();
  },
  success: function (message) {
    Toast.fire(message, "linear-gradient(to right, #00b09b, #96c93d)");
  },
  error: function (message) {
    Toast.fire(message, "linear-gradient(to right, #ff5f6d, #ffc371)");
  },
  warning: function (message) {
    Toast.fire(message, "linear-gradient(to right, #f9d423, #ff4e50)");
  },
  info: function (message) {
    Toast.fire(message, "linear-gradient(to right, #0000bb, #00ffff)");
  },
}
