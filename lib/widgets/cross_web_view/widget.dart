part of 'cross_web_view.dart';

class CrossWebView extends StatefulWidget{


  static bool get supportedPlatform{
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
      case "windows":
        return true;
      default:
        return false;
    }
  }


  const CrossWebView({
    super.key,
    this.headers = const {},
    required this.startUrl,
    this.onUrlChanged,

  });

  final Map<String,String> headers;
  final String startUrl;
  final void Function(String url)? onUrlChanged;

  @override
  State<CrossWebView> createState() => _CrossWebViewState();
}

class _CrossWebViewState extends State<CrossWebView> {

  final CrossWebViewController _controller = CrossWebViewController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<CrossWebViewController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {

          switch(Platform.operatingSystem){
            case "android":
              return WebViewWidget(
                  controller: _controller.webViewController,
              );
            case "ios":
            case "macos":
            case "windows":
              return Container(
                color: Colors.white,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      headers: widget.headers,
                      url: WebUri(widget.startUrl)),
                  onWebViewCreated: (controller) {
                    _controller.inAppWebViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    if(url!=null) {
                      widget.onUrlChanged?.call(url.path);
                    }
                  },
                  onUpdateVisitedHistory: (controller, url, _){
                    if(url!=null) {
                      widget.onUrlChanged?.call(url.origin+url.host+url.path+(url.query.isNotEmpty?"?${url.query}":""));
                    }
                  },
                ),
              );
              // return Webview(_controller.webViewController2);
            default:
              throw Exception("Unsupported platform: ${Platform.operatingSystem}");
          }


        }
    );
  }


}
