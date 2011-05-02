/* we are progressive enhancement guru gods */
/* Thankyou stack overflow ;) */
// http://stackoverflow.com/questions/436710/element-appendchild-chokes-in-ie
var css = document.createElement('style')
css.setAttribute('type', 'text/css')
var cssText = '.noscript { display: none; }';
if(css.styleSheet) { // IE does it this way
        css.styleSheet.cssText = cssText
} else { // everyone else does it this way
        css.appendChild(document.createTextNode(cssText));
}
$('html head').get(0).appendChild(css)

$(document).ready(function() {
  $('.single-checkbox-form').livequery(single_checkbox_form)
  // AJAXly call feedback?date=DATESTRING when date field changes, populate help box with result
  $("#prediction_deadline_text").keyup(deadline_changed)
  $("#response_comment").keyup(response_preview)
  $("a[class~=facebox]").facebox()
})

// Focus first input field on page
// 1. first empty element
// 2. first element with an error if all full
// 3. first element if all full and no errors
$(document).ready(function() {
  var input = $('form .input[value=]:first');
  if ( input.size() == 0) {
    input = $('.error .input:first');
    if ( input.size() == 0) {
      input = $('input[type=text]:first');
    }
  }
  input.focus();
})

function single_checkbox_form() {  
  $(this).find('input[type=checkbox]').click(function() {
    form_container = $(this.form).parent()
    $(form_container).find('p.note').text('Saving…')
    $(this.form).ajaxSubmit({
      success: function(content) {
        form_container.html(content)
      },
      error: function(xhr) { form_container.html("There was an error.") }
    })
  });
}

function deadline_changed(event) {
  if (this.value == '') {
    $('#prediction_deadline_preview').text('')
  }
  else {
    $('#prediction_deadline_text_preview').text('Waiting…')
    $.ajaxSync({
      url: '/feedback',
      type: 'GET',
      data: 'date=' + this.value,
      dataType: 'text',
      timeout: 1000,
      error: function() {
        $('#prediction_deadline_text_preview').text("I can't work out a time from that, sorry")
      },
      success: function(text) {
        $('#prediction_deadline_text_preview').text(text)
      }
    })
  }
}

function response_preview(event) {
  if (this.value == '') {
    $('#response_comment_preview').text('')
  }
  else {
    $.ajaxSync({
      url: '/responses/preview',
      type: 'GET',
      data: 'response[comment]=' + this.value,
      dataType: 'text',
      timeout: 1000,
      success: function(text) {
        $('#response_comment_preview').html(text)
      }
    });
  }
}
