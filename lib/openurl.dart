import 'package:url_launcher/url_launcher.dart';

class OpenUrl {
  static openUrl(String url) async {
    // const url = "https://www.caminitodelrey.info";
    await launch(
      url,
      // forceWebView: true,
    );
  }
}
