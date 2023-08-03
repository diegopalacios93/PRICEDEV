window.closeChatSession = function () {
    setTimeout(() => {
        const buttons = document.getElementsByClassName('dialog-button-0');
        buttons[0].click();
    }, 100);
}