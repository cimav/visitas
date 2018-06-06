$(document).on('ready turbolinks:load', function() {
    $('.modal').modal();
});

function openModal(modal){
    modal.modal('open');
}

function openInNewTab(url) {
    var win = window.open(url, '_blank');
    win.focus();
}