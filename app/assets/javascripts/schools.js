$('document').ready(function () {
    $('input[type=file].centerImageFileField').unbind('change').change(function () {
        $('.centerImage').hide();
    });
});