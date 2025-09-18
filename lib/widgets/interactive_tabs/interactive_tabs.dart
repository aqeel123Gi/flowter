import 'package:flutter/material.dart';
import '../child_size_detector/child_size_detector.dart';

class InteractiveTabsController{

  final List<void Function(int index)> listenersOnStartTabChanging = <void Function(int index)>[];

  void addListenerOnStartTabChanging(void Function(int index) listener){
    listenersOnStartTabChanging.add(listener);
  }

  void removeListenerOnStartTabChanging(void Function(int index) listener){
    listenersOnStartTabChanging.remove(listener);
  }


  InteractiveTabsController({
    int initialIndex = 0
  }){
    currentIndex = initialIndex;
  }
  void Function(int index) toTab = (x){};
  int currentIndex = -1;
  late int Function() length;
}

class InteractiveTabs extends StatefulWidget {

  const InteractiveTabs({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.parentHeight = false,
    this.initIndex = 0,
    this.direction,
    this.onMove,
    this.onChanged,
    this.disappearHiddenChildren = true,
    this.movement = const Duration(milliseconds: 800),
    this.controller,
    this.separationColor = Colors.transparent,
    this.scrollable = true
  });


  final int initIndex;
  final List<Widget> children;
  final bool parentHeight;
  final TextDirection? direction;
  final void Function(double indexShift)? onMove;
  final void Function(int index)? onChanged;
  final bool disappearHiddenChildren;
  final Duration movement;
  final InteractiveTabsController? controller;
  final Color separationColor;
  final bool scrollable;
  final EdgeInsets padding;


  @override
  State<InteractiveTabs> createState() => _InteractiveTabsState();
}

class _InteractiveTabsState extends State<InteractiveTabs>{


  _isLTR(){
    return (widget.direction??Directionality.of(context))==TextDirection.ltr;
  }

  double _getPointerShift(double start,double current){
    return (_isLTR()? current-start : start-current)/_parentSize!.width;
  }

  double _stopIndex(double currentShift){
    return currentShift.round().toDouble();
  }

  final Map<int,double> _childrenHeights = {};

  _updateShowingIndexes(double currentShift){
    double tmp = -currentShift;
    int floor = tmp.floor();
    if(floor>=0 && floor<widget.children.length){
      _appearedWidgetsIndexes[floor] = true;
      _lastAppearedWidgetsIndexes[floor] = DateTime.now();
    }
    if(tmp>floor && floor+1>=0 && floor+1<widget.children.length){
      _appearedWidgetsIndexes[floor+1] = true;
      _lastAppearedWidgetsIndexes[floor+1] = DateTime.now();
    }
    Future.delayed(widget.movement,(){
      if(!mounted){
        return;
      }
      setState(() {
        DateTime now = DateTime.now();
        double tmp = -(_indexShift+_pointerShift);
        for(int i=0;i<widget.children.length;i++){
          if(
          now.difference(_lastAppearedWidgetsIndexes[i]).inMilliseconds>widget.movement.inMilliseconds &&
              !(tmp.floor()==i || (tmp>tmp.floor() && tmp.floor()+1==i))
          ){
            _appearedWidgetsIndexes[i] = false;
          }
        }
      });
    });
  }


  Size? _parentSize;
  late List<bool> _appearedWidgetsIndexes;
  final List<GlobalKey> _keys = [];
  late List<DateTime> _lastAppearedWidgetsIndexes;
  late double _indexShift = 0;

  double? _startXp;
  double _prePointerShift = 0;
  double _pointerShift = 0;

  @override
  void initState() {
    _indexShift = -widget.initIndex.toDouble();
    _appearedWidgetsIndexes = List.filled(widget.children.length, false);
    _lastAppearedWidgetsIndexes = List.filled(widget.children.length, DateTime(2000));
    _appearedWidgetsIndexes[widget.initIndex]=true;
    for (var _ in widget.children) {
      _keys.add(GlobalKey());
    }
    if(widget.controller!=null){
      widget.controller!.currentIndex = widget.initIndex;
      widget.controller!.toTab = (index){
          _toTab(index);
      };
      widget.controller!.length = (){
        return widget.children.length;
      };
    }
    super.initState();
  }

  void _toTab(int index){

    if(widget.children.length>index && index>=0){
      widget.controller!.currentIndex = index;
      setState(() {
        _updateShowingIndexes(_indexShift);
        _appearedWidgetsIndexes[index] = true;
        _indexShift = (-index).toDouble();
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _indexShift = (-index).toDouble();
        _updateShowingIndexes(_indexShift);
        _onTabViewChanged(index);
      });

    }else{
      throw Exception("Out of index");
    }
  }

  void _onTabViewChanged(int index){
    if(widget.onChanged!=null){
      widget.onChanged!(index);
    }
    if(widget.controller!=null){
      for (var element in widget.controller!.listenersOnStartTabChanging) {
        element(index);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerUp: widget.scrollable?(pointer){
          setState((){
            if(_startXp!=null && (_getPointerShift(_startXp!,pointer.localPosition.dx) - _prePointerShift).abs()>0.1){
              if(_getPointerShift(_startXp!,pointer.localPosition.dx) > _prePointerShift){
                _indexShift++;
              }else{
                _indexShift--;
              }
            }else{
              _indexShift = _stopIndex(_indexShift+_pointerShift);
            }
            if(_indexShift>0){
              _indexShift=0;
            }else if(-_indexShift>widget.children.length-1){
              _indexShift = -widget.children.length+1;
            }
            _pointerShift = 0;

          });
          Future.delayed(const Duration(milliseconds: 50),(){
            _prePointerShift = 0;
          });
          _startXp = null;
          _onTabViewChanged((-_indexShift).floor());
          if(widget.controller!=null){

            widget.controller!.currentIndex = (-_indexShift).floor();

          }

          _updateShowingIndexes(_indexShift+_pointerShift);
        }:null,
        child: GestureDetector(
    onHorizontalDragStart: widget.scrollable?(pointer){
    _startXp = pointer.localPosition.dx;
    }:null,
    onHorizontalDragUpdate: widget.scrollable?(pointer){
    setState((){
    _pointerShift = _getPointerShift(_startXp!, pointer.localPosition.dx);
    // if(_indexShift+_pointerShift>0){ //TODO
    //
    // }else if(-_indexShift>widget.children.length-1){
    //
    // }
    double tmp = _pointerShift;
    Future.delayed(const Duration(milliseconds: 50),(){
    _prePointerShift = tmp;
    });
    if(widget.onMove!=null){
    widget.onMove!(-(_indexShift+_pointerShift));
    }
    _updateShowingIndexes(_indexShift+_pointerShift);
    });
    }:null,


    child:LayoutBuilder(builder: (context,constraints){
          _parentSize = Size(constraints.maxWidth,constraints.maxHeight);
            return Container(
              height: widget.parentHeight?_parentSize?.height:_childrenHeights.isEmpty || !_childrenHeights.containsKey(-_indexShift.floor())?0:_childrenHeights[-_indexShift.floor()],
              color:Colors.transparent,
              child:Stack(
              children: [
                ...List.generate(widget.children.length, (index) => _Tab(
                padding: widget.padding,
                duration: widget.movement,
                  left: _isLTR()?((_indexShift+_pointerShift+index)*_parentSize!.width):null,
                  right: _isLTR()?null:((_indexShift+_pointerShift+index)*_parentSize!.width),
                  width: _parentSize!.width,
                  appeared: _appearedWidgetsIndexes[index],
                    child: _appearedWidgetsIndexes[index]? widget.parentHeight?SizedBox(key: _keys[index],child:widget.children[index]):ChildSizeDetector(
                        onChange:(size){
                          setState((){
                            _childrenHeights[index] = size.height;
                          });
                        },child:SizedBox(key: _keys[index],child:widget.children[index])):const SizedBox()
              )),
                ...List.generate(widget.children.length+1, (index) => AnimatedPositioned(
                    duration: widget.movement,
                    curve: Curves.easeOutExpo,
                    left: _isLTR()?((_indexShift+_pointerShift+index)*_parentSize!.width)+0.5:null,
                    right: _isLTR()?null:((_indexShift+_pointerShift+index)*_parentSize!.width)-0.5,
                    width: 1,
                    top: 0,
                    bottom: 0,
                    child: Container(color: widget.separationColor)
                ))
              ]
            )
          );
        })
    ));
  }
}

class _Tab extends StatelessWidget{

  const _Tab({
    required this.padding,
    required this.duration,
    required this.left,
    required this.right,
    required this.width,
    required this.appeared,
    required this.child,
  });

  final EdgeInsets padding;
  final Duration duration;
  final double? left;
  final double? right;
  final double width;
  final Widget child;
  final bool appeared;

  @override
  Widget build(BuildContext context) => Stack(children:[
    AnimatedPositioned(
      duration: duration,
      curve: Curves.easeOutExpo,
      left: left,
      right: right,
      width: width,
      top: 0,
      bottom: 0,
      child: appeared?Padding(padding: padding,
      child: child):const SizedBox()
  )]);

}
