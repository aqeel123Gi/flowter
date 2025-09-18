import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef AdSliderListener = void Function(int currentIndex);

class AdSliderController extends ChangeNotifier {
  int _currentIndex = 0;
  PageController? _pageController;

  int get currentIndex => _currentIndex;

  void _attach(PageController controller, int initialPage) {
    _pageController = controller;
    _currentIndex = initialPage;
  }

  void _detach() {
    _pageController = null;
  }

  void _setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<void> to(int index,
      {Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeInOut}) async {
    if (_pageController == null) return;
    await _pageController!.animateToPage(index, duration: duration, curve: curve);
    _setCurrentIndex(index);
  }
}

class AdSlider extends StatefulWidget {
  final List<Widget> children;
  final Duration autoPlayInterval;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final TextDirection? textDirection;
  final AdSliderController? controller;

  const AdSlider({
    Key? key,
    required this.children,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.transitionDuration = const Duration(milliseconds: 500),
    this.transitionCurve = Curves.easeInOut,
    this.textDirection,
    this.controller,
  }) : super(key: key);

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  late final PageController _pageController;
  late AdSliderController _controller;

  Timer? _timer;
  Timer? _resumeTimer;
  int _currentPage = 1;
  bool _isUserInteracting = false;

  bool get isRTL =>
      (widget.textDirection ?? Directionality.of(context)) == TextDirection.rtl;

  List<Widget> get _loopedChildren {
    final list = widget.children;
    return [
      _GesturePassthrough(
        child: list.last,
        controller: _pageController,
        onUserInteractionStart: _onUserInteractionStart,
        onUserInteractionEnd: _onUserInteractionEnd,
      ),
      ...list.map(
            (w) => _GesturePassthrough(
          child: w,
          controller: _pageController,
          onUserInteractionStart: _onUserInteractionStart,
          onUserInteractionEnd: _onUserInteractionEnd,
        ),
      ),
      _GesturePassthrough(
        child: list.first,
        controller: _pageController,
        onUserInteractionStart: _onUserInteractionStart,
        onUserInteractionEnd: _onUserInteractionEnd,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _controller = widget.controller ?? AdSliderController();
    _controller._attach(_pageController, _currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  void _setCurrentPage(int index) {
    _currentPage = index;
    _controller._setCurrentIndex(index);
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_isUserInteracting) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!_pageController.hasClients) return;
      _currentPage += isRTL ? -1 : 1;
      _pageController
          .animateToPage(
        _currentPage,
        duration: widget.transitionDuration,
        curve: widget.transitionCurve,
      )
          .then((_) => _handleLoop());
    });
  }

  void _onUserInteractionStart() {
    if (!_isUserInteracting) {
      _isUserInteracting = true;
      _timer?.cancel();
      _resumeTimer?.cancel();
    }
  }

  void _onUserInteractionEnd() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      _isUserInteracting = false;
      _startAutoPlay();
    });
  }

  void _handleLoop() {
    final count = widget.children.length;
    if (_currentPage == count + 1) {
      _setCurrentPage(1);
      _pageController.jumpToPage(_currentPage);
    } else if (_currentPage == 0) {
      _setCurrentPage(count);
      _pageController.jumpToPage(_currentPage);
    } else {
      _controller._setCurrentIndex(_currentPage);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _controller._detach();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return PageView.builder(
          controller: _pageController,
          itemCount: _loopedChildren.length,
          reverse: isRTL,
          onPageChanged: (index) {
            _setCurrentPage(index);
            _handleLoop();
          },
          itemBuilder: (context, index) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: _loopedChildren[index],
            );
          },
        );
      },
    );
  }
}

class _GesturePassthrough extends StatelessWidget {
  final Widget child;
  final PageController controller;
  final VoidCallback onUserInteractionStart;
  final VoidCallback onUserInteractionEnd;

  const _GesturePassthrough({
    Key? key,
    required this.child,
    required this.controller,
    required this.onUserInteractionStart,
    required this.onUserInteractionEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        HorizontalDragGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
              (HorizontalDragGestureRecognizer instance) {
            instance
              ..onStart = (_) {return onUserInteractionStart();}
                ..onUpdate = (details) {
                if (controller.hasClients) {
                  controller.position.moveTo(
                    controller.position.pixels - details.delta.dx,
                  );
                }
              }
              ..onEnd = (_) {return onUserInteractionEnd();}
              ..onCancel = (){
                return onUserInteractionEnd();
              };
          },
        ),
      },
      child: child,
    );
  }
}
