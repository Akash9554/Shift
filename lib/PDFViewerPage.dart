import 'package:flutter/material.dart';


class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      /*body: WebView(
        initialUrl: '$pdfUrl',
        javascriptMode: JavascriptMode.unrestricted,
      ),*/
    );
  }
}
