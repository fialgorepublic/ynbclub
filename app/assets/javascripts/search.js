$(document).on('turbolinks:load', function () {
  filterByName();
  timer = '';
  function filterByName() {
    $(".post-sorting").removeClass("add-z-minus");
    $(".class-z").removeClass("add-z-minus");
    $('.search-result').hide();
    $('.cross-icon').hide();
    $(".search-by-title, .search-by-subject").on('z', function (e) {
      if (e.keyCode === 13) {
        e.preventDefault();
        $(".post-sorting").addClass("add-z-minus");
        $(".class-z").addClass("add-z-minus");
        if ($(this).val() == '') { return; }
        $('.cross-icon').fadeIn();
        submitSearchForm();
      }
    });

    $('.cross-icon').click(function () {
      fadeOutContent();
    });

    $(".search-by-title, .search-by-subject").on("input", function () {
      if ($(this).val() == '') {
        fadeOutContent(this);

        return;
      }
      $(".post-sorting").addClass("add-z-minus");
      $(".class-z").addClass("add-z-minus");
      $('#conversations').addClass("add-z-minus");

      $('.cross-icon').fadeIn();
      // clear the timer if it's already set:
      clearTimeout(timer);
      timer = setTimeout(function () {
        submitSearchForm()
      }, 500);
    });
  }

  function submitSearchForm() {
    var elem = document.getElementById('search-form');
    Rails.fire(elem, 'submit');
  }

  function fadeOutContent(ele) {
    $('.cross-icon').fadeOut();
    $('.search-result').fadeOut();
    $(ele).val('');
    $(".post-sorting").removeClass("add-z-minus");
    $(".class-z").removeClass("add-z-minus");
    $('#conversations').removeClass("add-z-minus");
  }

  $(document).mouseup(function (e) {
    var container = $(".search-result");
    if(container.length == 0) { return; }
    if (!container.is(e.target) && container.has(e.target).length === 0) {
      container.hide();
      $('.cross-icon').fadeOut();
      $('.search-result').fadeOut();
      $("#group_title").val('');
      $("#conversation_subject").val('');
      $(".post-sorting").removeClass("add-z-minus");
      $(".class-z").removeClass("add-z-minus");
    }
  });
});

