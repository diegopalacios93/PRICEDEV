window.opensidetab = function (content){
    $("body").append(content);
    console.log("agregando linea");
}
window.closesidetab = function (contentId){
    var content = $('#'+contentId);
    content.remove();
} 