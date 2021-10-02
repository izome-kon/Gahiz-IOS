package com.gahez
import com.freshchat.consumer.sdk.Freshchat;
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FcmMessageService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        if (Freshchat.isFreshchatNotification(remoteMessage)) {
            Freshchat.handleFcmMessage(this, remoteMessage);
        }
    }
}