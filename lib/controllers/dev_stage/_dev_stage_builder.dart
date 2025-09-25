part of 'dev_stage.dart';



class DevStageBuilder extends StatefulWidget {
  const DevStageBuilder({
    super.key,
    this.comment,
    this.onDev,
    this.onStaging,
    this.onProduction
  });

  final String? comment;
  final Widget Function(BuildContext context)? onDev;
  final Widget Function(BuildContext context)? onStaging;
  final Widget Function(BuildContext context)? onProduction;

  @override
  State<DevStageBuilder> createState() => _DevStageBuilderState();
}

class _DevStageBuilderState extends State<DevStageBuilder> {

  DevStage _stage = DevStageController.stage;
  late List<DevStage> _stages;

  @override
  void initState() {
    _stages = [
      if(widget.onProduction!=null) DevStage.production,
      if(widget.onStaging!=null) DevStage.staging,
      if(widget.onDev!=null) DevStage.development,
    ];
    super.initState();
  }


  void _toNextStage(){
    setState(() {
      _stage = _stages.nextOf(_stage,true);
    });
  }


  String get _letters{
    switch(_stage){
      case DevStage.production:
        return "PRO";
      case DevStage.staging:
        return "STG";
      case DevStage.development:
        return "DEV";
    }
  }


  @override
  Widget build(BuildContext context) {

    if(DevStageController.stage==DevStage.production){
      return widget.onProduction != null?widget.onProduction!(context):const SizedBox();
    }

    switch (_stage) {
      case DevStage.production:
        return widget.onProduction==null?const SizedBox():_highlight(widget.onProduction!(context));
      case DevStage.staging:
        return widget.onStaging==null?const SizedBox():_highlight(widget.onStaging!(context));
      case DevStage.development:
        return widget.onDev==null?const SizedBox():_highlight(widget.onDev!(context));
    }

  }


  Widget _highlight(Widget child) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: DevStageController.colors[_stage]!.withAlpha(10),
                border: Border.all(
                  color: DevStageController.colors[_stage]!,
                )
            ),
                    ),
          )),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: (){
              _toNextStage();
            },
            child: Container(
              decoration: BoxDecoration(
                color: DevStageController.colors[_stage]!,
                border: Border.all(
                  color: DevStageController.colors[_stage]!.withAlpha(100),
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right:4, top: 0),
                child: Text(_letters + (widget.comment!=null?' : ${widget.comment}':''),style: const TextStyle(color: Colors.black, fontSize: 12, fontFamily: '', fontWeight: FontWeight.w500),),
              ),
            ),
          ),
        )
      ]
    );
  }


}
