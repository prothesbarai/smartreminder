import 'package:flutter/widgets.dart';
import 'app_open_ad_helper.dart';

class AppOpenLifecycleManager with WidgetsBindingObserver {
  AppOpenLifecycleManager._();

  static final instance = AppOpenLifecycleManager._();

  bool _initialized = false;
  bool _isInBackground = false;


  void initialize() {
    if (_initialized) {return;}
    WidgetsBinding.instance.addObserver(this);
    _initialized = true;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _initialized = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state,) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _isInBackground = true; // >>> app goto background
        break;
      case AppLifecycleState.resumed:
      // >>> Will only show when it has actually returned from the background. But Not Show Cold Start
        if (_isInBackground) {
          _isInBackground = false;
          AppOpenAdHelper.show(cooldownSeconds: 300);
        }
        break;
      default:
        break;
    }
  }
}