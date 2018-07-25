package push.notifications

class SendPushMessageController {

    SendPushMessageService sendPushMessageService;

    static layout = "main"
    def index() {
        render view:"index"
    }

    def sendPayload(String payload) {
        sendPushMessageService.sendPushMessageToAllSubscribers(payload);
        render "Done!"
    }
}
