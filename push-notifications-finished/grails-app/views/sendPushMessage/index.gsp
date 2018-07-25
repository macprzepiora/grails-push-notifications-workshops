<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta name="layout" content="main"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Sending push notifications</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>
    <asset:javascript src="application.js"/>

</head>

<body>
<section class="row colset-2-its">
    <div>
        Would you like to receive notifications from this website?
    </div>

    <div>
        <button id="subscribeBtn">Yes, please</button>
    </div>
    <div>
        <a id="send" href="sendPayload?payload='Hello!'" style="display: none" target="_blank">
        Click here to send notifications to all subscribed users</a>
    </div>
</section>

<script>
    const publicVapidKey = "BJ0Ebjs5i5YUJpMv9QtxPmonaYCtXr02ljkz6peDZrlZRnsHVcLoYvv3u2c++hQiPg7opldOXF/EQN0SytewaZ8="

    function urlBase64ToUint8Array(base64String) {
        const padding = '='.repeat((4 - base64String.length % 4) % 4);
        const base64 = (base64String + padding).replace(/\-/g, '+').replace(/_/g, '/');

        const rawData = window.atob(base64);
        const outputArray = new Uint8Array(rawData.length);

        for (let i = 0; i < rawData.length; ++i) {
            outputArray[i] = rawData.charCodeAt(i);
        }
        return outputArray;
    }

    function getRegistrationPromise() {
        var promiseChain = navigator.serviceWorker.getRegistration().then(registration => {
                if (!registration) {
                    return navigator.serviceWorker.register("/sw.js")
                } else {
                    return registration
                }
            }
        )
        return promiseChain;
    }

    function getRegistrationWhenServiceWorkerIsActive(registration) {
        var serviceWorker = registration.active || registration.waiting || registration.installing || null;
        if (serviceWorker) {
            var resultPromise = new Promise(function (resolve, reject) {
                    if (serviceWorker.state === "activated") {
                        resolve(registration)
                    } else {
                        serviceWorker.addEventListener("statechange", e => {
                                if (e.target.state === "activated") {
                                    resolve(registration)
                                }
                            }
                        );
                    }
                }
            );
            return resultPromise
        } else {
            throw new Error("No service worker could be found")
        }
    }

    function subscribeToPushWith(registration, publicVapidKey) {
        const subscriptionOption = {
            userVisibleOnly: true,
            applicationServerKey: urlBase64ToUint8Array(publicVapidKey)
        }
        return registration.pushManager.subscribe(subscriptionOption)
    }

    function sendSubscriptionToBackend(subscription) {
        var backend = "/pushSubs"
        var stringifiedSubscription = subscription.toJSON()
        var flattenedSubscription = {
            endPoint: stringifiedSubscription.endpoint,
            p256dhKey: stringifiedSubscription.keys.p256dh,
            auth: stringifiedSubscription.keys.auth
        }

        return fetch(backend, {
            method: "POST",
            headers: {
                "Content-Type": 'application/json'
            },
            body: JSON.stringify(flattenedSubscription)
        }).then(response => {
                if (!response.ok) {
                    throw new Error('Bad status code from server')
                }
            }
        )
    }

    var subscribeBtn = window.document.getElementById("subscribeBtn");
    subscribeBtn.addEventListener("click", event => {
            getRegistrationPromise()
                .then(getRegistrationWhenServiceWorkerIsActive)
                .then(registration => subscribeToPushWith(registration, publicVapidKey))
                .then(sendSubscriptionToBackend)
                .then(() => subscribeBtn.disabled = true)
                .then(()=> {
                    window.document.getElementById("send").style.display = "inline"
                    }
                )
                .catch(err => console.log(err));
        }
    );

    navigator.serviceWorker.getRegistration().then(registration => {
        if (registration) {
            return registration.pushManager.getSubscription()
        }}).then(subscription => {
        if(subscription) {
            subscribeBtn.disabled = true;
            window.document.getElementById("send").style.display = "inline"
        }
    })




</script>
</body>
</html>
