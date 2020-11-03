import 'globals.dart' as globals;
import 'package:vibration/vibration.dart';
import 'main.dart' as main;


enum InternalPushNotificationType{ STOP_READING,VERIFIED_ORIGINAL_PRODUCT,VERIFIED_NOT_ORIGINAL_PRODUCT}

abstract class InternalPushNotificationListener {
  void onInternalNotification(InternalPushNotificationType type, Map<int,String> mex);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class InternalPushNotificationListenerProviderSingleton {
  static final InternalPushNotificationListenerProviderSingleton _instance = new InternalPushNotificationListenerProviderSingleton.internal();

  factory InternalPushNotificationListenerProviderSingleton() => _instance;

  InternalPushNotificationListenerProviderSingleton.internal() {
    globals.localLog(runtimeType.toString(),":: InternalPushNotificationListenerProviderSingleton.internal Start");
    initState();
    _subscribers = new List<InternalPushNotificationListener>();
    globals.localLog(runtimeType.toString(),":: InternalPushNotificationListenerProviderSingleton.internal Completed");
  }


  List<InternalPushNotificationListener> _subscribers;

  bool _canVibrate = true;
  void initState() async {
    _canVibrate = await Vibration.hasVibrator();

    globals.localLog(runtimeType.toString(),":: initState Start");

    globals.localLog(runtimeType.toString(),":: initState Completed");
  }



  void unsubscribe(InternalPushNotificationListener listener) {
    final String _methodName="unsubscribe";
    _subscribers.remove(listener);
    globals.localLog(runtimeType.toString()+"::"+_methodName, "Completed");
  }

  void subscribe(InternalPushNotificationListener listener) {
    globals.localLog(runtimeType.toString(),":: subscribe ");
    _subscribers.add(listener);
  }

  void dispose(InternalPushNotificationListener listener) {
    globals.localLog(runtimeType.toString(),":: dispose ");
    for(var l in _subscribers) {
      if(l == listener)
        _subscribers.remove(l);
    }
  }

  void notifyNewInternalPush(InternalPushNotificationType type,Map<int, String> mex) {
    if (_canVibrate) {
      Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
    }
    //main.soundManager.playNotifySequence();


    globals.localLog(runtimeType.toString(),":: notifyNewInternalPush ");
    _subscribers.forEach((InternalPushNotificationListener s) => s.onInternalNotification(type,mex));

  }


}