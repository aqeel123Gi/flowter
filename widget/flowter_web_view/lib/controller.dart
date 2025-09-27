part of 'flowter_web_view.dart';


class CrossWebViewController extends WidgetController<CrossWebView> {


  late InAppWebViewController inAppWebViewController;
  late WebViewController webViewController;
  // late WebviewController webViewController2;


  @override
  void onInit() {
    switch(Platform.operatingSystem){
      case "android":
        webViewControllerInitialize();
        break;
      // case "ios":
      // case "macos":
      //   webViewControllerInitialize();
      //   break;
      // case "windows":
      //   webViewController2Initialize();
      //   break;
    }
  }



  void webViewControllerInitialize(){
    webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.startUrl), headers: widget.headers)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onUrlChange: (UrlChange urlChange) {
            if(widget.onUrlChanged!=null){
              widget.onUrlChanged!(urlChange.url!);
            }
          },
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) {

          },
          onHttpError: (HttpResponseError error) {

          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }




  // void webViewController2Initialize(){
  //   webViewController2 = WebviewController();
  //   webViewController2.url.listen((url){
  //     if(widget.onUrlChanged!=null){
  //       widget.onUrlChanged!(url);
  //     }
  //   });
  //   ()async{
  //     await webViewController2.initialize();
  //     await webViewController2.loadUrl(widget.startUrl);
  //     updateState();
  //   }();
  // }




}