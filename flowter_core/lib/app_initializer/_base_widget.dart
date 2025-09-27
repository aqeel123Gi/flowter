part of 'app_initializer.dart';



class AppBaseWidget extends StatefulWidget{
  const AppBaseWidget({
    super.key,
    required this.appCustomization,
  });

  final AppCustomization appCustomization;

  @override
  State<AppBaseWidget> createState() => _AppBaseWidgetState();

}


class _AppBaseWidgetState extends State<AppBaseWidget>{

  @override
  void initState() {

    TemplateController.addListenerOnPageSetAsHome((page) => UiKeyController.oneLayer([]));
    TemplateController.addListenerOnPagePushed((page) => UiKeyController.pushLayer([]));
    TemplateController.addListenerOnPagePop((page) => UiKeyController.popLayer());

    TemplateController.initialize(widget.appCustomization.templateCustomization);

    addPostFrameCallback(() async {


      // loopExecution(
      //     function:(){
      //       try {
      //         ShorebirdController.patchUpdate();
      //       } catch (e) {
      //         DebuggerConsole.setPinnedLine(
      //             "PATCH UPDATE", "ERROR: ${parseErrorMessage(e)}",
      //             color: Colors.red);
      //       }
      //     },
      //     stopOn: () => false,
      //     breakDuration: const Duration(minutes: 5)
      // );
    });

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