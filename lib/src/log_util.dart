/// Log Util.
class Log {
  static const String _defTag = 'windego_utils-Log';
  static bool _debugMode = false; //是否是debug模式,true: log v 不输出.
  static String _tagValue = _defTag;

  static void init({
    String tag = _defTag,
    bool isDebug = false,
  }) {
    _tagValue = tag;
    _debugMode = isDebug;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, ' e ', object);
  }

  static void d(Object object, {String tag}) {
    if (_debugMode) {
      _printLog(tag, ' d ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    String da = object.toString();
    tag = tag ?? _tagValue;
    print('$tag $stag ==>  $da');
    return;
  }
}
