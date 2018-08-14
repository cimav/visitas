function setVisitsHeight(){
    var screenHeight = window.innerHeight;
    var searchHeight = document.getElementById("visits-search-form").offsetHeight;
    document.getElementById("visits-wrapper").style.maxHeight = screenHeight-searchHeight-290 + "px";
}


function openEditRoomVisitModal(room_visit_id){
    $('#edit_room_visit_modal').modal('open');
    $('#edit_room_visit_preloader').show();
    $('#edit_room_visit_content').html('');

    $.get( "/visits/edit_room_visit/"+room_visit_id)
        .done(function( data ) {
            $('#edit_room_visit_preloader').hide();
            $('#edit_room_visit_content').html(data);
        });
}

function openEditVisitPersonModal(visit_person_id, token){
    $('#edit_visit_person_modal').modal('open');
    $('#edit_visit_person_preloader').show();
    $('#edit_visit_person_content').html('');

    $.ajax({
        url: "/visits/edit_visit_person/"+visit_person_id,
        type: 'GET',
        data: {is_token: token},
        //dataType: 'json',
        success: function (data) {
            $('#edit_visit_person_preloader').hide();
            $('#edit_visit_person_content').html(data);
        }
    });
}


function loadVisitPeople(visit_id, is_token){
    $.ajax({
        url: "/visits/"+visit_id+"/load_people",
        type: 'GET',
        data:{is_token: is_token},
        beforeSend: function (){
            $('#visit_people_preloader').show();
            $('#edit_room_visit_content').html('');
        },
        success: function(res) {
            $('#visit_people').html(res);
        },
        complete: function () {
            $('#visit_people_preloader').hide();
        }
    });
}


// Se hace el submit de manera asíncrona, desactivando el submit por defecto
$(function() {
    $('form#add_people_form').submit(function(event) {
        event.preventDefault(); // Prevent the form from submitting via the browser
        var form = $(this);
        var visit_id = form.attr('visit_id');
        $.ajax({
            type: form.attr('method'),
            url: form.attr('action'),
            data: form.serialize()
        }).success(function(data) {
            Materialize.toast(data.message, 3000);
            $('#visit_person_name').val('');
        }).fail(function(data) {
            Materialize.toast("Error al enviar información", 4000)
            // Optionally alert the user of an error here...
        }).done(function () {
            loadVisitPeople(visit_id);
        });
    });
});