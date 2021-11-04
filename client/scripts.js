$(".menu-toggle").click(function(){
    $(".links").toggleClass("mobile-nav");
    $(this).toggleClass("is-active");
 });

/*$(function() {
  
    // contact form animations
    $("#contact").click(function() {
      $("#contact-container").fadeToggle();
    })

    $("#contact-close").click(function() {
        $("#contact-container").fadeToggle();
      })
      
    $(document).mouseup(function (e) {
      var container = $("#contact-container");
      var form = $("#contact-form");
  
      if (!form.is(e.target) // if the target of the click isn't the container...
          && form.has(e.target).length === 0) // ... nor a descendant of the container
      {
          container.fadeOut();
      }
    });
    
  });*/