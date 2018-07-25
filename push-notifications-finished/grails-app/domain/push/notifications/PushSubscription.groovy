package push.notifications

import grails.rest.Resource

@Resource(uri='/pushSubs', formats = ['json'])
class PushSubscription {
    String endPoint
    String p256dhKey
    String auth

    static constraints = {
    }
}
