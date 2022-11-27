import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double lat, double lng) async {
    String url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot open maps';
    }
  }
}
