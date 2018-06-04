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
