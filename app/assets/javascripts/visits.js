function setVisitsHeight(){
    var screenHeight = window.innerHeight;
    var searchHeight = document.getElementById("visits-search-form").offsetHeight;
    document.getElementById("visits-wrapper").style.maxHeight = screenHeight-searchHeight-250 + "px";
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

function addPerson(visit_id){
    $.ajax({
        url: "/visits/"+visit_id+"/add_person",
        type: 'POST',
        data:{
          visit_person : {
              name: $('#add_person_name').val(),
              person_type: $('#add_person_type').val()
          }
        },
        error: function (){
            //Mostrar toast de error
        },
        success: function(res) {
            loadVisitPeople(visit_id);
            Materialize.toast(res, 3000)
        },
        complete: function () {
            $('#add_person_name').val('')
        }
    });
}