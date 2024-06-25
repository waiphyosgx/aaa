import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IFrameViewer extends StatefulWidget {
  final String link;

  const IFrameViewer({super.key, required this.link});

  @override
  _IFrameViewerState createState() => _IFrameViewerState();
}

class _IFrameViewerState extends State<IFrameViewer> {
  late WebViewController _controller;
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
    ),
  };
  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (_)async{
        final height = await _controller.runJavaScriptReturningResult('document.body.scrollHeight;');
        print(height);
      }
    ));
    _loadIframe();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }

  void _loadIframe() {
    if (_controller != null) {
      String html = '''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Embedded Iframe</title>
            <style>
                .widget-security-details-information-iframe {
                   display: block;
                   width: 100%;
                   height: 100vh;
                    border: none;
                    overflow: auto;
                }
            </style>
        </head>
        <body>
            <iframe class="widget-security-details-information-iframe" src="${widget.link}"></iframe>
        </body>
        </html>
      ''';
      _controller.loadHtmlString(html);
    }
  }
}
