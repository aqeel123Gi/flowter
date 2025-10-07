part of 'app_initializer.dart';



class _AppBaseWidget extends StatefulWidget{


  const _AppBaseWidget({
    required this.appCustomization,
  });

  final AppCustomization appCustomization;

  @override
  State<_AppBaseWidget> createState() => _AppBaseWidgetState();

}


class _AppBaseWidgetState extends State<_AppBaseWidget>{

  @override
  void initState() {

    TemplateController.addListenerOnPageSetAsHome((page) => UiKeyController.oneLayer([]));
    TemplateController.addListenerOnPagePushed((page) => UiKeyController.pushLayer([]));
    TemplateController.addListenerOnPagePop((page) => UiKeyController.popLayer());

    TemplateController.initialize(widget.appCustomization.templateCustomization);

    BrightnessController.addListener((){
      setState((){});
    });

    DictionaryController.addOnLanguageChangedListener((){
      setState((){});
    });

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: Locale(DictionaryController.currentLanguage.code),
        debugShowCheckedModeBanner: false,
        themeMode: BrightnessController.mode,
        theme: widget.appCustomization.lightTheme,
        darkTheme: widget.appCustomization.darkTheme,
        home: PreferredScreen(
            content: PublicListener(
                child: Material(
                    child: DebuggerConsole(
                        child: Scaling(
                          scaleFrom: widget.appCustomization.appScale ?? () => 1,
                          child:Directionality(
                            textDirection: DictionaryController.currentTextDirection,
                            child: NoScroller(
                                active: widget.appCustomization.noScrollbar,
                                child: TemplateController.builder(context))
                        )
                    )
                )
              )
            )
        )
    );
  }

}