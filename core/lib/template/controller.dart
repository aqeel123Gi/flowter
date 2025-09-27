part of 'template.dart';

class TemplateController {

  static late BuildContext context;
  static List<TemplateData> pages = [];
  static List<TemplateData> lastPageToBeHidden = [];
  static TemplateData? pendingNextPage;




  static List<void Function(TemplateData page)> listenersOnPagePushed = [];
  static List<void Function(TemplateData page)> listenersOnPagePop = [];
  static List<void Function(TemplateData page)> listenersOnPageSetAsHome = [];


  static late TemplateCustomization _customization;






  static TemplateData get currentTemplateData{
    return pages.last;
  }


  static bool defaultBackButtonPressed(){
    return true;
  }


  static void addListenerOnPagePushed(void Function(TemplateData page) listener){
    listenersOnPagePushed.add(listener);
  }


  static void removeListenerOnPagePushed(void Function(TemplateData page) listener){
    listenersOnPagePushed.remove(listener);
  }


  static void addListenerOnPagePop(void Function(TemplateData page) listener){
    listenersOnPagePop.add(listener);
  }


  static void removeListenerOnPagePop(void Function(TemplateData page) listener){
    listenersOnPagePop.remove(listener);
  }


  static void addListenerOnPageSetAsHome(void Function(TemplateData page) listener){
    listenersOnPageSetAsHome.add(listener);
  }


  static void removeListenerOnPageSetAsHome(void Function(TemplateData page) listener){
    listenersOnPageSetAsHome.remove(listener);
  }


  static void initialize(TemplateCustomization customization) {
      _customization = customization;
      setHomePage(customization.initTemplateData());
  }


  static void updateCurrentTemplateData(TemplateData Function(TemplateData currentTemplateData) newTemplateData){
    pages.last = newTemplateData(pages.last);
    WidgetController.updateStates();
  }



  static bool isGoingBack = false;
  static void goBack(){
    if(isGoingBack || !TemplateController.pages.last.onBackButtonPressed()){
      return;
    }
    else if(TemplateController.pages.length > 1 && TemplateController.pages.last.shownBackButton) {
      TemplateController.pop();
    }
    else if(TemplateController.pages.length==1){
      SystemNavigator.pop();
    }
  }


  static Widget builder (BuildContext context){

    TemplateController.context = context;

    UiKeyController.scaleFrom(TemplateController._customization.scaleFrom??() => 1);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (_,__) {
          goBack();
        },
        child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: _customization.builder(context,pages)
            )

    );
  }


  static void setHomePage(TemplateData page) {
    pages = [page];
    WidgetController.updateStates();
    for(var listener in listenersOnPageSetAsHome){
      listener(page);
    }
  }


  static void push(TemplateData page) async{

    pages.last.setCurrency(false);
    pendingNextPage = page;
    WidgetController.updateStates();
    Future.delayed(page.showAfter,(){
      pages.add(pendingNextPage!);
      pendingNextPage = null;
      WidgetController.updateStates();
    });
    for(var listener in listenersOnPagePushed){
      listener(page);
    }
  }


  static void pop({State? state, Widget? body, TemplateData? templateData}){

    if(pages.length==1) return;

    TemplateData data = pages.last;

    if(state!=null){
      data = TemplateData.ofBodyState(state)!;
    }else if(templateData!=null){
      data = templateData;
    }else if(body!=null){
      data = TemplateData.ofBody(body)!;
    }else {
      data = pages.last;
    }

    data.setCurrency(false);
    WidgetController.updateStates();
    isGoingBack = true;
    Future.delayed(data.hideAfter,(){
      pages.remove(data);
      lastPageToBeHidden.insert(0,data..animateController.hide());
      pages.last.setCurrency(true);
      WidgetController.updateStates();
      isGoingBack = false;
      Future.delayed(data.hideTransformData.duration,(){
        lastPageToBeHidden.removeLast();
        WidgetController.updateStates();
      });
      for(var listener in listenersOnPagePop){
        listener(pages.last);
      }

    });

  }

}



mixin TemplateWidget on StatefulWidget{
  late void Function() updateCurrentState;
}



mixin TemplateState on State<TemplateWidget>{
  @override
  void initState() {
    widget.updateCurrentState = (){
      setState(() {});
    };
    super.initState();
  }
}

