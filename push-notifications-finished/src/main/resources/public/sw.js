
self.addEventListener('install', function(event) {
    console.log('Service Worker installing.');
})

self.addEventListener('activate', function(event) {
    console.log('Service Worker activating.');
})


self.addEventListener('push', function(event) {
    const promiseChain = self.registration.showNotification(event.data.text());
    event.waitUntil(promiseChain);
});
