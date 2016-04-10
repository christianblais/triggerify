$('#handlers select').on('change', function (event) {
  var $target = $(event.target);
  var handler = $target.val();

  $target.parent('.section-cell').find('[data-handler]').each(function (index, element) {
    var $element = $(element);

    if ($element.data('handler') == handler) {
      $element.show();
      $element.find('input').prop('disabled', false);
    } else {
      $element.hide();
      $element.find('input').prop('disabled', true);
    }
  });
}).trigger('change');
