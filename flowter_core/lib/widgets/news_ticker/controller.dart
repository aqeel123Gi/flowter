part of 'news_ticker.dart';


class _NewsTickerController extends WidgetController<NewsTicker>{

  ScrollController scrollController = ScrollController();
  late AnimationController animationController;
  double scrollOffset = 0.0;

  late double tickerWidth;


  @override
  void onPostInit() {
    animationController = AnimationController(
      vsync: state as SingleTickerProviderStateMixin,
      duration: Duration(days: 999),
    );

    animationController.addListener(() {
      if (scrollController.hasClients) {
        scrollOffset += widget.velocity(tickerWidth) / 60;
        if (scrollOffset > scrollController.position.maxScrollExtent) {
          scrollOffset = 0;
        }
        scrollController.jumpTo(scrollOffset);
      }
    });

    animationController.repeat();


  }

  @override
  void onStartDisposing() {
    animationController.dispose();
    scrollController.dispose();
    super.onStartDisposing();
  }


}