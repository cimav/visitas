$(document).on('ready turbolinks:load', function() {
    $('.modal').modal();
});

function openModal(modal){
    modal.modal('open');
}