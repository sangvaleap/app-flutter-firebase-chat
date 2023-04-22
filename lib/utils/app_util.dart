import 'package:flutter/foundation.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppUtil {
  static void debugPrint(var value) {
    if (kDebugMode) print(value);
  }

  static getTimeAgo(DateTime dt) {
    return timeago.format(dt, allowFromNow: true, locale: 'en_short');
  }

  static bool checkIsNull(value) {
    return [null, "null", ""].contains(value);
  }
}
