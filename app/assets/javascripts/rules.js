$('[data-handler-list]').on('change', 'select', function (event) {
  var $target = $(event.target);
  var handler = $target.val();

  $target.closest('.section-cell').find('[data-handler]').each(function (index, element) {
    var $element = $(element);

    if ($element.data('handler') == handler) {
      $element.show();
      $element.find('input').prop('disabled', false);
    } else {
      $element.hide();
      $element.find('input').prop('disabled', true);
    }
  });
})

$('body').on('click', '[data-add]', function (event) {
  event.preventDefault();

  var target = $(event.currentTarget).attr("data-add");
  var $clone = $("[data-" + target + "-template]").children().clone();
  $clone.find('input[type="hidden"]').attr('value', 0);
  $clone.appendTo("[data-" + target + "-list]");
  $clone.find('select').trigger('change');
});

$('body').on('click', '[data-destroy]',  function (event) {
  event.preventDefault();

  var parent = $(event.target).closest("[data-section]");
  parent.hide().find('input[type="hidden"]').attr('value', 1);
});

$('select').trigger('change');
