part of 'notification_helper.dart';

String token = '';

_onTokenEvent(String event) {
  token = event;
  log('TokenEvent $token');
}

_onTokenError(Object error) {
  log('TokenErrorEvent $error');
}

_onMessageReceived(huawei.RemoteMessage data) {
  log('on Message notification ${data.notification?.toMap()}');
  log('on Message data ${data.data}');
  log('on Message body ${data.notification?.body}');

  if (Platform.isAndroid) {
    scheduleNotification(data.notification?.title ?? "",
        data.notification?.body ?? "", json.encode(data.data));
  }
  updateUserFunctions(notify: data.data);
}

init() async {
  ///To get Token
  huawei.Push.getToken("");
  huawei.Push.getTokenStream.listen(
    _onTokenEvent,
    onError: _onTokenError,
  );
  huawei.Push.onMessageReceivedStream.listen(
    _onMessageReceived,
    onError: _onTokenError,
  );

  await huawei.Push.getInitialNotification();
  await huawei.Push.getNotifications();

  huawei.Push.getIntentStream.listen(
    _onTokenEvent,
    onError: _onTokenError,
  );
}
