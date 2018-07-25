package push.notifications

import grails.gorm.transactions.Transactional
import nl.martijndwars.webpush.Notification
import nl.martijndwars.webpush.PushService
import org.bouncycastle.jce.provider.BouncyCastleProvider

import java.security.Security

@Transactional
class SendPushMessageService {

    def privateVapidKey = "AN1t5XnrafzKnd2drzDxM8Tw2cXipwB8X2o0rQyT04ED"
    def publicVapidKey = "BJ0Ebjs5i5YUJpMv9QtxPmonaYCtXr02ljkz6peDZrlZRnsHVcLoYvv3u2c" +
            "++hQiPg7opldOXF/EQN0SytewaZ8"
    def jwtSubject = "mailto:maciej@przepiora.eu"

    def sendPushMessageToAllSubscribers(String payload) {
        if (!Security.getProvider(BouncyCastleProvider.PROVIDER_NAME)) {
            Security .addProvider(new BouncyCastleProvider())
        }
        PushService pushService = new PushService(publicVapidKey, privateVapidKey, jwtSubject)
        PushSubscription.all.forEach { ps ->
            Notification notification = new Notification(
                    ps.endPoint, ps.p256dhKey, ps.auth, payload)
            pushService.send(notification)
        }
    }

}
