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

    <script>
    window.addEventListener("load", function() {
        function urlBase64ToUint8Array(base64String) {
            const padding = '='.repeat((4 - base64String.length % 4) % 4);
            const base64 = (base64String + padding)
                .replace(/\-/g, '+')
                .replace(/_/g, '/');

            const rawData = window.atob(base64);
            const outputArray = new Uint8Array(rawData.length);

            for (let i = 0; i < rawData.length; ++i) {
                outputArray[i] = rawData.charCodeAt(i);
            }
            return outputArray;
        }

        const publicVapidKey = "BNWDsA8-km4OhGxV3joKmFIg96BUobLwBZfv3r1t0hWR7HI_Uw7nu3do-JNtpRMsZ9InVoisHMcMdCCE5GMfKJ4="
        if(!navigator.serviceWorker && !window.PushManager) {
            throw new Error("No support");
        }
        navigator.serviceWorker.register("/sw.js")
            .then(waitForSW)
            .then(getSubscription)
            .then(sendSubscriptionToBackend)

        function waitForSW(registration) {
            let serviceWorker = registration.installing || registration.waiting ||
                registration.active || null
            if(serviceWorker.state === "activated") {
                return registration
            } else {
                return new Promise(function(resolve, reject) {
                    serviceWorker.addEventListener("statechange", e=> {
                        if(e.target.state === "activated"){
                            resolve(registration)
                        }
                    })
                })
            }
        }

        function getSubscription(registration) {
            const subscriptionOptions = {
                userVisibleOnly: true,
                applicationServerKey: urlBase64ToUint8Array(publicVapidKey)
            }
            return registration.pushManager.subscribe(subscriptionOptions);
        }

        function sendSubscriptionToBackend(subscription) {
        }
    })
</script>
</head>

<body>
<section class="row colset-2-its">
    <div>Experimentation area for notifications</div>
    <button id="clickHereBtn">Click here</button>
</section>

</body>
</html>
