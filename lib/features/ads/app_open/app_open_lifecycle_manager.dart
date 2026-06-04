import 'package:flutter/widgets.dart';
import 'app_open_ad_helper.dart';

class AppOpenLifecycleManager with WidgetsBindingObserver {
  AppOpenLifecycleManager._();

  static final instance = AppOpenLifecycleManager._();

  bool _initialized = false;

  void initialize() {
    if (_initialized) {return;}
    WidgetsBinding.instance.addObserver(this);
    _initialized = true;
  }

  void dispose() {WidgetsBinding.instance.removeObserver(this);}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state,) {
    if (state == AppLifecycleState.resumed) {AppOpenAdHelper.show(cooldownSeconds: 300,);}
  }
}