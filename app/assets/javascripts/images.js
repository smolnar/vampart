$(document).on('turbolinks:load', function() {
  $('input#image_photo').change(function() {
    $('form#new_image')[0].submit();

    $('button#pick-a-photo').attr('disabled', true);
  });

  $('button#pick-a-photo').click(function() {
    $('input#image_photo').click();
  });
});
