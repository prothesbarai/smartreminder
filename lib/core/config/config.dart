class Config {

  static String get app => "Android";

  // >>> For Android ===========================================================
  static String get currVersionAndroid => "AndroidV-1(1.0.1)";
  static String get currVersionMinAndroid => "1.0.4";
  static String get releaseVersionForAppVersionPageAndroid => "1th Release";
  static String get releaseDateForAppVersionPageAndroid => "14 May 2026";
  // <<< For Android ===========================================================



  // >>> For IOS ===============================================================
  static String get currVersionIOS => "iOSV-1.0.0";
  static String get currVersionMinIOS => "1.0.0";
  static String get releaseVersionForAppVersionPageIOS => "1st Release";
  static String get releaseDateForAppVersionPageIOS => "05 May 2026";
  // <<< For IOS ===============================================================



  /// >>> Dynamic Version Based on Platform ====================================
  static String get currVersion {
    if (app == "iOS") {
      return currVersionIOS;
    } else {
      return currVersionAndroid;
    }
  }
  static String get currVersionMin {
    if (app == "iOS") {
      return currVersionMinIOS;
    } else {
      return currVersionMinAndroid;
    }
  }
  static String get releaseVersionForAppVersionPage{
    if(app == "iOS"){
      return releaseVersionForAppVersionPageIOS;
    }else{
      return releaseVersionForAppVersionPageAndroid;
    }
  }
  static String get releaseDateForAppVersionPage{
    if(app == "iOS"){
      return releaseDateForAppVersionPageIOS;
    }else{
      return releaseDateForAppVersionPageAndroid;
    }
  }
/// <<< Dynamic Version Based on Platform ====================================


}