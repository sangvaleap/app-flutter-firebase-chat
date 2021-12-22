
import 'package:timeago/timeago.dart' as timeago;

getTimeAgo(DateTime dt){
   return timeago.format(dt, allowFromNow: true, locale: 'en_short');
}