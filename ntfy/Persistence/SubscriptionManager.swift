import Foundation

/// Manager to combine persisting a subscription to the data store.
/// Uses local polling for notifications.
struct SubscriptionManager {
    private let tag = "SubscriptionManager"
    var store: Store

    func subscribe(baseUrl: String, topic: String) {
        Log.d(tag, "Subscribing to \(topicUrl(baseUrl: baseUrl, topic: topic))")
        let subscription = store.saveSubscription(baseUrl: baseUrl, topic: topic)
        poll(subscription)
    }

    func unsubscribe(_ subscription: Subscription) {
        Log.d(tag, "Unsubscribing from \(subscription.urlString())")
        DispatchQueue.main.async {
            store.delete(subscription: subscription)
        }
    }
    
    func poll(_ subscription: Subscription) {
        poll(subscription) { _ in }
    }
    
    func poll(_ subscription: Subscription, completionHandler: @escaping ([Message]) -> Void) {
        // This is a bit of a hack but it prevents us from polling dead subscriptions
        if (subscription.baseUrl == nil) {
            Log.d(tag, "Attempting to poll dead subscription failed")
            completionHandler([])
            return
        }
        
        let user = store.getUser(baseUrl: subscription.baseUrl!)?.toBasicUser()
        Log.d(tag, "Polling from \(subscription.urlString()) with user \(user?.username ?? "anonymous")")
        ApiService.shared.poll(subscription: subscription, user: user) { messages, error in
            guard let messages = messages else {
                Log.e(tag, "Polling failed", error)
                completionHandler([])
                return
            }
            Log.d(tag, "Polling success, \(messages.count) new message(s)", messages)
            if !messages.isEmpty {
                DispatchQueue.main.sync {
                    for message in messages {
                        store.save(notificationFromMessage: message, withSubscription: subscription)
                    }
                }
            }
            completionHandler(messages)
        }
    }
}
