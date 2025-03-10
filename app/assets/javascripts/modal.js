Modal = {
  merge_options: function (opt, default_opt) {
    return Object.assign({}, default_opt, opt);
  },
  default_options: {
    backdrop: 'static',
    keyboard: false
  },
  init: function () {
    return this;
  },
  show: function (title, partial, options) {
    options = this.merge_options(options || {}, this.default_options);

    $('#modal').modal(options);
    $('#modal #modal-title').html(title);
    $('#modal #content').html('');
    $(partial).appendTo('#modal #content');

    return this;
  },
  close: function () {
    $('#modal #modal-title').html('');
    $('#modal #content').html('');
    $('#modal').modal('hide');

    return this;
  },
  setTitle: function (title) {
    $('#modal #modal-title').html(title);
    return this;
  },
  setContent: function (content) {
    $('#modal #content').html(content);
    return this;
  },
  setErrors: function (partial) {
    $('#modal #todo_errors').html('');
    $('#modal #todo_errors').append(partial);
    this.validation();
    return this;
  },
  appendContent: function (content) {
    $(content).appendTo('#modal #content');
    return this;
  },
  validation: function () {
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
  }
}.init();
