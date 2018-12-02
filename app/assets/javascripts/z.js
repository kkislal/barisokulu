(function($){

  var turboloadF = function() {

    var vController = $('body').data('controller');
    var vAction = $('body').data('action');

    $('[data-toggle="popover"]').popover()

    $('#exampleModal').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget) // Button that triggered the modal
      var recipient = button.data('whatever') // Extract info from data-* attributes
      // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
      // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
      var modal = $(this)
      modal.find('.modal-title').text('New message to ' + recipient)
      modal.find('.modal-body input').val(recipient)
    })

    var pathname = window.location.href;
    $("#login_org_url").val(pathname);

    $("input[data-role=tagsinput], select[multiple][data-role=tagsinput]").tagsinput();


    if (vAction == 'edit' || vAction == 'new') {
      Materialize.updateTextFields();

      TinyMCERails.configuration.default = {
        selector: "textarea.tinymce",
        toolbar: ["formatselect | bold italic strikethrough forecolor backcolor | styleselect | image link | table | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent  | removeformat"],
        plugins: "advlist autolink lists link image charmap print preview anchor textcolor,searchreplace visualblocks code fullscreen,insertdatetime media table contextmenu paste code help wordcount",
        themes: ["modern"],
        convert_urls: false,
        relative_urls: false,
        remove_script_host: false,
        style_formats: [
          {
            title: 'Image Left',
            selector: 'img',
            styles: {
              'float': 'left',
              'margin': '0 10px 0 10px'
            }
          },
          {
            title: 'Image Right',
            selector: 'img',
            styles: {
              'float': 'right',
              'margin': '0 0 10px 10px'
            }
          }
        ]
      };

      TinyMCERails.initialize('default', {

      });

    }

  };

  $(document).on('turbolinks:load', turboloadF);

})(jQuery); // end of jQuery name space
