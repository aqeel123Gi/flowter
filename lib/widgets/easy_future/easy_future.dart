import 'package:flowter/functions/post_state.dart';
import 'package:flutter/material.dart';
import '../animated_transform_switcher/animated_transform_switcher.dart';

enum FutureBuilderState{
  none,
  loading,
  error,
  completed
}


class AQFutureBuilderController{

  FutureBuilderState _state = FutureBuilderState.none;

  void addListener(void Function(FutureBuilderState state) onChanged){
    _listeners.add(onChanged);
  }

  void removeListener(void Function(FutureBuilderState state) onChanged){
    _listeners.remove(onChanged);
  }

  final Set<void Function(FutureBuilderState state)> _listeners = {};


  FutureBuilderState get state => _state;
  void Function() repeat = (){
    throw Exception("repeat is not implemented");
  };
}


class AQFutureBuilder<T> extends StatefulWidget {

  const AQFutureBuilder({
    super.key,
    this.controller,
    required this.futureFunction,
    this.onError,
    this.onDataReturned,
    required this.waitingBuilder,
    required this.errorBuilder,
    required this.dataBuilder,
  });


  final AQFutureBuilderController? controller;
  final Future<T> Function() futureFunction;
  final Widget Function(BuildContext context, T data, void Function() repeater) dataBuilder;
  final Widget Function(Object exception, StackTrace stacktrace, void Function() repeater) errorBuilder;
  final Widget Function() waitingBuilder;
  final void Function(Object exception, StackTrace stacktrace)? onError;
  final void Function(T data)? onDataReturned;



  @override
  State<AQFutureBuilder> createState() => _AQFutureBuilderState<T>();
}

class _AQFutureBuilderState<T> extends State<AQFutureBuilder<T>> {


  void _changeState(FutureBuilderState state){
    if(widget.controller!=null){
      widget.controller!._state = state;
      for (var fun in widget.controller!._listeners) {
        fun(state);
      }
    }
    setState(() {});
  }


  late Future<T> _future;

  Future<T> modifiedFutureFunction()async{
    _changeState(FutureBuilderState.loading);
    try{
      // if(kDebugMode){
      //   await Future.delayed(const Duration(milliseconds: 1000));
      //   throw Exception("This is a debug exception");
      // }
      T data = await widget.futureFunction();
      _changeState(FutureBuilderState.completed);
      if(widget.onDataReturned!=null){
        widget.onDataReturned!(data);
      }
      return data;
    }
    catch(e,s){
      Future.microtask(()=>throw e);
      _changeState(FutureBuilderState.error);
      if(widget.onError!=null){
        widget.onError!(e,s);
      }
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();

    _future = modifiedFutureFunction();
    if(widget.controller!=null){
      widget.controller!.repeat = (){
        _repeat();
      };
    }

    addPostFrameCallback((){
      Future.delayed(const Duration(milliseconds: 1000),(){
        if(mounted){
          setState(() {
            _waitingLogo = false;
          });
        }
      });
    });
  }

  void _repeat(){
    if(mounted){
      setState(() {
        _future = modifiedFutureFunction();
      });
    }
  }


  bool _waitingLogo = true;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context,AsyncSnapshot<T> snapshot) {
          return AnimatedTransformingSwitcher(
            duration: const Duration(milliseconds: 500),
            showAfterDuration: const Duration(milliseconds: 300),
            switcher: "$_waitingLogo${snapshot.connectionState}${snapshot.hasData}${snapshot.hasError}",
            builder: (context, switcherKey){

              if (snapshot.hasError) {
                return widget.errorBuilder(snapshot.error!,snapshot.stackTrace!,_repeat);
              }

              if(_waitingLogo || snapshot.connectionState == ConnectionState.waiting){
                return widget.waitingBuilder();
              }

              if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.none) {
                return widget.dataBuilder(context, snapshot.data as T, _repeat);
              }

              throw Exception("Unknown connection state: ${snapshot.connectionState}");
            },

          );


        });
  }
}
