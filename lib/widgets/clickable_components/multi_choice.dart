import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import '../../controllers/global_future/global_future.dart';
import '../../controllers/ui_key/ui_key.dart';
import '../buttons/full_stacked_button.dart';

class MultiChoice<T> extends StatefulWidget {

  const MultiChoice({
    super.key,
    this.enabled = true,
    required this.onNotChosenText,
    this.nullChoicesText = "",
    this.repeatingText = "",
    required this.height,
    required this.chosen,
    this.choices,
    this.futureChoices,
    required this.numberDecoration,
    required this.numberDecorationOnDisabled,
    required this.decoration,
    required this.decorationOnFocused,
    required this.clickedButtonColor,
    required this.onPressed, required this.titleStyle, required this.titleWidth, required this.choiceStyle, required this.hintStyle,
    required this.pendingWidget,
    this.onErrorDecoration
  });

  final bool enabled;
  final Widget pendingWidget;
  final TextStyle titleStyle;
  final TextStyle choiceStyle;
  final TextStyle hintStyle;
  final String nullChoicesText;
  final String repeatingText;
  final String onNotChosenText;
  final double height;
  final double titleWidth;
  final Set<T> chosen;
  final Map<T,String>? choices;
  final GlobalFuture<Map<T,String>>? futureChoices;
  final Color clickedButtonColor;
  final BoxDecoration numberDecoration;
  final BoxDecoration numberDecorationOnDisabled;
  final BoxDecoration decoration;
  final BoxDecoration decorationOnFocused;
  final BoxDecoration? onErrorDecoration;
  final void Function() onPressed;

  @override
  State<MultiChoice<T>> createState() => _MultiChoiceState<T>();
}

class _MultiChoiceState<T> extends State<MultiChoice<T>> {

  void _update() {
    if(mounted){
      try{
        setState(() {});
      }catch(_){}
    }
  }

  @override
  void initState() {
    if(widget.futureChoices!=null){
      widget.futureChoices!.addOnUpdatedListener(_update);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.futureChoices!=null){
      widget.futureChoices!.removeOnUpdatedListener(_update);
    }
    super.dispose();
  }


  Widget _chosenListWidget (Map<T, String> fromChoices)=> ListView(
    shrinkWrap: true,
    padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      children: [Builder(builder: (context){

        List<T> list = widget.chosen.toList()..sort();

        return Row(children: <Widget>[
          for(var i in list) Text(fromChoices[i]!,style: widget.choiceStyle),
        ].insertBetweenElements(SizedBox(width: widget.choiceStyle.fontSize!*2))..add(SizedBox(width: widget.height-9)));

      })]);

  Widget _dp(Widget child) => Padding(padding: EdgeInsetsDirectional.only(end: widget.height-9),child: child);


  Widget get _content {
    if(widget.choices!=null){
      if(widget.chosen.isEmpty){
        return _dp(Text(widget.onNotChosenText,style: widget.hintStyle));
      }
      return _chosenListWidget(widget.choices!);
    }


    if(widget.futureChoices!=null){
      if(widget.futureChoices!.pending){
        return _dp(widget.pendingWidget);
      }
      if(widget.futureChoices!.error!=null){
        return _dp(Text(widget.repeatingText,style: widget.choiceStyle));
      }
      if(widget.futureChoices!.data==null){
        return _dp(Text(widget.nullChoicesText,style: widget.hintStyle));
      }
      if(widget.chosen.isEmpty){
        return _dp(Text(widget.onNotChosenText,style: widget.hintStyle));
      }

      return _chosenListWidget(widget.futureChoices!.data!);
    }



    return _dp(Text(widget.nullChoicesText,style: widget.hintStyle));
  }

  BoxDecoration _decoration(bool focused) {
    if (focused) {
      return widget.decorationOnFocused;
    }else if(widget.futureChoices!=null && widget.futureChoices!.error != null){
      return widget.onErrorDecoration!;
    }else{
      return widget.decoration;
    }
  }

    void Function()? get _onPressed {
      if(
        widget.enabled && (widget.choices!=null || (widget.futureChoices!=null && !widget.futureChoices!.pending && widget.futureChoices!.data!=null))) {
        return widget.onPressed;
      }
      if(widget.enabled && widget.futureChoices!=null && widget.futureChoices!.error!=null){
        return widget.futureChoices!.repeat;
      }
      return null;


    }


    final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {


    return UiKey(
      key: _key,
      fixed: false,
      focusable: _onPressed!=null,
      builder:(context,focused)=> ZoomingClickEffect(
        enabled: _onPressed!=null,
        child: AnimatedContainer(
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 2000),
          clipBehavior: Clip.antiAlias,
          height: widget.height,
          decoration: _decoration(focused),
          child: FilledButtonAsset(
            foregroundColor: widget.clickedButtonColor,
            onPressed: _onPressed,
            child: Row(children: [
              const SizedBox(width: 3),
              AnimatedOpacity(
                opacity: widget.choices!=null || (widget.futureChoices!=null && widget.futureChoices!.data!=null)? 1.0 : 0.0,
                curve: Curves.easeOutCirc,
                duration: const Duration(milliseconds: 2000),
                child: AnimatedContainer(
                  width: widget.height-9,
                  height: widget.height-9,
                    curve: Curves.easeOutCirc,
                    duration: const Duration(milliseconds: 2000),
                    decoration: (!widget.enabled ||

                      (widget.enabled &&
                          (widget.choices==null &&
                              (widget.futureChoices==null || widget.futureChoices!.pending || widget.futureChoices!.data==null )))
                  )?
                  widget.numberDecorationOnDisabled : widget.numberDecoration,
                  child: Center(child: Text(widget.chosen.length.toString(),style: widget.titleStyle))
                ),
              ),
              Expanded(child: Center(child: _content))
            ]),
          ),
        ),
      ),
    );
  }
}
