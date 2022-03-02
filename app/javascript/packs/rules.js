document.addEventListener("turbolinks:load", function (event) {
  $('[data-handler-list]').on('change', '[data-handler]', function (event) {
    var $target = $(event.target);
    var handler = $target.val();

    $target.closest('[data-section]').find('[data-handler-details]').each(function (index, element) {
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

  // Polaris' Selects don't work outside of React, so... here's a manual implementation
  $('body').on('change', '.Polaris-Select__Input', function (event) {
    $target = $(event.target);
    $value = $target.find('option:selected').text();
    $parent = $target.closest('.Polaris-Select');
    $content = $parent.find('.Polaris-Select__SelectedOption');

    $content.html($value);
  });

  $('[data-add]').on('click', function (event) {
    event.preventDefault();

    var target = $(event.currentTarget).attr("data-add");
    var $clone = $("[data-" + target + "-template]").clone();
    var new_id = new Date().getTime();


    $clone = $($clone.html().replace(/[\_|\[](\d+)[\_|\]]/g, function(x) {
      return x.replace(/(\d+)/, new_id)
    }));

    $clone.find('[data-destroy-input]').attr('value', 0);

    $clone.appendTo("[data-" + target + "-list]");

    $clone.find('select').trigger('change');
  });

  $('body').on('click', '[data-destroy]',  function (event) {
    event.preventDefault();

    var parent = $(event.target).closest("[data-section]");
    parent.hide().find('[data-destroy-input]').attr('value', 1);
  });

  $('select').trigger('change');
});
