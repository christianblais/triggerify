$('[data-handler-list]').on('change', '[data-handler]', function (event) {
  var $target = $(event.target);
  var handler = $target.val();

  $target.closest('.section-cell').find('[data-handler-details]').each(function (index, element) {
    var $element = $(element);

    if ($element.attr('data-handler-details') == handler) {
      $element.show();
      $element.find(':input').prop('disabled', false);
    } else {
      $element.hide();
      $element.find(':input').prop('disabled', true);
    }
  });
});

$('[data-topic]').on('change', function (event) {
  var $target = $(event.target);
  var topic = $target.val();

  $('[data-topic-payload]').each(function (index, element) {
    var $element = $(element);

    if ($element.attr('data-topic-payload') == topic) {
      $element.show();
    } else {
      $element.hide();
    }
  });
});

$('[data-topic-payload-toggle]').on('click', function (event) {
  event.preventDefault();

  $(event.target).siblings('[data-topic-payload-details]').toggle();
});

$('body').on('click', '[data-add]', function (event) {
  event.preventDefault();

  var target = $(event.currentTarget).attr("data-add");
  var $clone = $("[data-" + target + "-template]").clone();
  var new_id = new Date().getTime();


  $clone = $($clone.html().replace(/[\_|\[](\d+)[\_|\]]/g, function(x) {
    return x.replace(/(\d+)/, new_id)
  }));

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
