part of 'template.dart';

enum BackgroundType{
  transparent,
  blurred,
  solid
}


class TemplateData<T extends Widget>{

  static TransformData _defaultStartTransform = TransformData(opacity: 0);
  static TransformData _defaultEndTransform = TransformData(opacity: 0);

  static void setDefaultTransforms({TransformData? start, TransformData? end}){
    _defaultStartTransform = start??_defaultStartTransform;
    _defaultEndTransform = end??_defaultEndTransform;
  }


  static TemplateData? ofBodyState(State state)=>TemplateController.pages.tryFirstWhere((td)=>td.body == state.widget)??TemplateController.pendingNextPage;
  static TemplateData? ofBody(Widget widget)=>TemplateController.pages.tryFirstWhere((td)=>td.body == widget)??TemplateController.pendingNextPage;
  static TemplateData? ofId(String id)=>TemplateController.pages.tryFirstWhere((td)=>td.id == id);

  final GlobalKey templateDataKey = GlobalKey();

  void setCurrency(bool isCurrent){
    _isCurrent = isCurrent;
  }
  bool _isCurrent = true;
  bool get isCurrent => _isCurrent;

  Type? get nextPageBodyType{
    int i = TemplateController.pages.indexOf(this);
    return i==TemplateController.pages.length-1?TemplateController.pendingNextPage?.body.runtimeType:TemplateController.pages[i+1].body.runtimeType;
  }



  Duration showAfter;
  Duration hideAfter;

  String id;
  String? title;
  List<ButtonData> pageButtons;
  bool Function() onBackButtonPressed = (){
    return true;
  };
  bool topPadding_;
  bool bottomPadding_;

  String? subtitle;

  T body;
  WidgetController<T>? bodyController;


  List<ButtonData>? tabs;
  bool shownBackButton;
  bool cutOnInsetsBottomRatio;
  late TransformData showTransformData;
  late AnimateController animateController;
  late TransformData hideTransformData;
  BackgroundType backgroundType;
  double shiftOnInsetsBottomRatio;
  MapEntry<Duration,void Function()>? onChoicesLongPress;


  TemplateData({
    required this.id,
    this.title,
    this.subtitle,
    this.topPadding_ = true,
    this.bottomPadding_ = true,
    this.cutOnInsetsBottomRatio = false,
    this.backgroundType = BackgroundType.solid,
    required this.body,
    this.pageButtons = const [],
    this.onBackButtonPressed = TemplateController.defaultBackButtonPressed,
    this.shownBackButton = true,
    this.shiftOnInsetsBottomRatio = 0,
    this.tabs,
    this.onChoicesLongPress,
    TransformData? showTransformData,
    TransformData? hideTransformData,
    this.showAfter = Duration.zero,
    this.hideAfter = Duration.zero,
  }){
    animateController = AnimateController();
    this.showTransformData = showTransformData??_defaultStartTransform;
    this.hideTransformData = showTransformData??_defaultEndTransform;
  }

  void changeFocusedTab(int i){
    if(tabs==null)return;
    for (var tab in tabs!) {
      tab.focused = false;
    }
    tabs![i].focused = true;
    bodyController?.updateState();
  }



  double get topPadding{
    return TemplateController._customization.topPadding(TemplateController.context,this);
  }


  double get bottomPadding{
    return TemplateController._customization.bottomPadding(TemplateController.context,this);
  }






}