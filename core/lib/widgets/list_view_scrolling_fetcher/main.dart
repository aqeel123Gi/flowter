import 'package:flutter/material.dart';

import '../animated_transform_switcher/animated_transform_switcher.dart';
import '../../functions/post_state.dart';

class ScrollingFetcher extends StatefulWidget {
  const ScrollingFetcher({
    super.key,
    required this.active,
    required this.fetcher,
    required this.onStateChanged,
    required this.onErrorBuilder,
    required this.indicator,
    required this.scrollController,
    required this.heightOfFetcherWidget
  });


  final bool active;
  final Future<void> Function() fetcher;
  final void Function() onStateChanged;
  final Widget Function(void Function() repeatingFunction) onErrorBuilder;
  final Widget indicator;
  final ScrollController scrollController;
  final double heightOfFetcherWidget;

  @override
  State<ScrollingFetcher> createState() => _ScrollingFetcherState();
}

class _ScrollingFetcherState extends State<ScrollingFetcher> {

  bool _isLoading = false;
  bool _isError = false;


  Future<void> fetching()async{
    _isLoading = true;
    _isError = false;
    try{
      await widget.fetcher();
      if(mounted){
        setState((){});
        widget.onStateChanged();
      }
    }catch(_){
      if(mounted){
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
      rethrow;
    }
    _isLoading = false;
  }


  void fetch(){
    try{
      if(widget.active && !_isLoading && widget.scrollController.positions.isNotEmpty && widget.scrollController.position.maxScrollExtent - widget.scrollController.offset < 200){
        fetching();
      }
    }catch(_){}

  }


  @override
  void initState() {
    addPostFrameCallback((){
      fetch();
    });
    widget.scrollController.addListener(fetch);
    super.initState();
  }



  @override
  void dispose() {
    widget.scrollController.removeListener(fetch);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(!widget.active){
      return const SizedBox();
    }

    return Container(
      height: widget.heightOfFetcherWidget,
      constraints: BoxConstraints(maxHeight: widget.heightOfFetcherWidget, minHeight: widget.heightOfFetcherWidget),
      child: AnimatedTransformingSwitcher(builder: (context, switcherKey) {
        if(_isError){
          return widget.onErrorBuilder((){
            setState(() {
              fetching();
            });
          });
        }else{
          return widget.indicator;
        }
      }, switcher: _isError, duration: const Duration(milliseconds: 300)),
    );

  }
}