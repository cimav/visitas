function setVisitsHeight(){
    var screenHeight = window.innerHeight;
    var searchHeight = document.getElementById("visits-search-form").offsetHeight;
    document.getElementById("visits-wrapper").style.maxHeight = screenHeight-searchHeight-250 + "px";
}