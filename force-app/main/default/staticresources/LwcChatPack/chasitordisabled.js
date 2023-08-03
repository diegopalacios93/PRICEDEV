window.chasitordisabled  = function (disabled) {
    var chasistor = $('.chasitorText');
    chasistor.value = 'hola'
    chasistor.disabled = disabled;
    chasistor.focus();
    console.log(disabled)
}
