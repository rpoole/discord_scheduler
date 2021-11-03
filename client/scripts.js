$(".menu-toggle").click(function(){
    $(".links").toggleClass("mobile-nav");
    $(this).toggleClass("is-active");
 });
 

//  Check for valid email syntax
// function validateEmail(email) {
//     var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
//     return re.test(email);
//   }

$(function() {
  
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
    
  });