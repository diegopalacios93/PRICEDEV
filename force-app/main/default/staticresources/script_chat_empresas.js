const timeOfWarning = 180;
var messagesDisabled = false;

function bindEvent(element, eventName, eventHandler) {
    if (element.addEventListener) {
        element.addEventListener(eventName, eventHandler, false);
    } else if (element.attachEvent) {
        element.attachEvent('on' + eventName, eventHandler);
    }
}

function disableChat() {
    var x = document.getElementsByClassName('chasitorControls');
    messagesDisabled = true;
    if (x[0] && !x[0].classList.contains('disablechat')) {
        x[0].classList.add('disablechat');
    }
}

function enableChat() {
    messagesDisabled = false;
    var x = document.getElementsByClassName('chasitorControls');
    if (x[0].classList.contains('disablechat')) {
        x[0].classList.remove('disablechat');
    }
    var chatMessages = document.getElementsByClassName('chatMessage');
    chatMessages[chatMessages.length - 2].style.display = "none";
    chatMessages[chatMessages.length - 3].style.display = "none";
}


bindEvent(window, 'message', function (e) {
    if (e.data === 'endChatSession')
        window.closeChatSession();

    if (e.data === 'awaitForDB')
        disableChat();

    if (e.data === 'awaitForUser')
        enableChat();

    if (e.data.data && e.data.data.event === 'chasitorChatRequestSuccessful') {
        window.chatKey = e.data.data.chasitorData.chatKey;
    }
});

window.addEventListener("message", receiveMessage, false);
function receiveMessage(event) {
    event.stopPropagation();
    var payload = event.data;
    if (payload && payload.type === "chasitor.sendMessage") {
        if (!messagesDisabled || payload.message === ' ')
            embedded_svc.postMessage("chasitor.sendMessage", payload.message);
    }
};

var initESW = function (gslbBaseURL) {
    embedded_svc.settings.displayHelpButton = true;
    embedded_svc.settings.language = 'es';

    embedded_svc.settings.enabledFeatures = ['LiveAgent'];
    embedded_svc.settings.entryFeature = 'LiveAgent';

    embedded_svc.init(
        'https://etb--digitale.my.salesforce.com',
        'https://digitale-etbglobant.cs19.force.com/chatdemo',
         gslbBaseURL,
        '00D290000001Uoo',
        'DEG_ETBChatServicioClienteEmpresas',
        {
            baseLiveAgentContentURL: 'https://c.la4-c1cs-phx.salesforceliveagent.com/content',
            deploymentId: '572290000004CRb',
            buttonId: '573290000004DCk',
            baseLiveAgentURL: 'https://d.la4-c1cs-phx.salesforceliveagent.com/chat',
            eswLiveAgentDevName: 'EmbeddedServiceLiveAgent_Parent04I29000000CahFEAS_177f39c44c5',
            isOfflineSupportEnabled: false
        }
    );
};

if (!window.embedded_svc) {
    var s = document.createElement('script');
    s.setAttribute('src', 'https://etb--digitale.my.salesforce.com/embeddedservice/5.0/esw.min.js');
    s.onload = function () {
        initESW(null);
    };
    document.body.appendChild(s);
} else {
    initESW('https://service.force.com');
}
