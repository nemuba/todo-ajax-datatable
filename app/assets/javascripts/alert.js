Alert = {
  merge_options: function (opt, default_opt) {
    return Object.assign({}, default_opt, opt);
  },
  default_options: {
    showCancelButton: false,
    showConfirmButton: true,
    confirmButtonColor: '#3085d6',
  },
  init: function () {
    this.default_options_info = this.merge_options({ icon: 'info' }, this.default_options);
    this.default_options_success = this.merge_options({ icon: 'success' }, this.default_options);
    this.default_options_error = this.merge_options({ icon: 'error' }, this.default_options);
    this.default_options_warning = this.merge_options({ icon: 'warning' }, this.default_options);
    this.default_options_confirm = this.merge_options({
      icon: 'question',
      showCancelButton: true,
      cancelButtonColor: '#f00',
      cancelButtonText: 'Cancelar',
      confirmButtonColor: '#0f0',
      confirmButtonText: 'Sim',
    }, this.default_options);

    return this;
  },
  fire: function (title, text, options) {
    return Swal.fire(this.merge_options({ title: title, text: text }, options));
  },
  confirm: function (title, text) {
    return this.fire(title, text, this.default_options_confirm);
  },
  success: function (title, text) {
    return this.fire(title, text, this.default_options_success);
  },
  error: function (title, text) {
    return this.fire(title, text, this.default_options_error);
  },
  warning: function (title, text) {
    return this.fire(title, text, this.default_options_warning);
  },
  info: function (title, text) {
    return this.fire(title, text, this.default_options_info);
  }
}.init();
