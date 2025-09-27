part of 'interactive_list_view.dart';

class InteractiveListView<T> extends StatefulWidget {

  const InteractiveListView({
    super.key,
    this.shrink = true,
    this.padding,
    this.physics,
    required this.initShown,
    required this.onShown,
    this.onHidden,
    this.parentScale = 1,
    this.childrenKeys,
    this.controller,
    required this.children
  });


  final bool shrink;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final List<T>? childrenKeys;
  final List<Widget> children;
  final void Function(List<T>) initShown;
  final void Function(T) onShown;
  final void Function(T)? onHidden;
  final ScrollController? controller;
  final double parentScale;


  @override
  State<InteractiveListView<T>> createState() => _InteractiveListViewState<T>();
}

class _InteractiveListViewState<T> extends State<InteractiveListView<T>>{

  final ScrollController _controller = ScrollController();

  ScrollController get _attachedController => widget.controller??_controller;

  final GlobalKey<AnimatedListState> _listViewKey = GlobalKey<AnimatedListState>();

  List<GlobalKey> currentChildrenGlobalKeys = [];
  List<T> currentChildrenKeys = [];
  List<Widget> currentChildren = [];
  List<T> shownChildren = [];

  int currentStartAppearedWidgetIndex = 0;

  _updateChildren(){
    bool updated = false;
    //Remove
    for(int i=currentChildren.length-1;i>=0;i--){
      if(!widget.childrenKeys!.contains(currentChildrenKeys[i])){
        _listViewKey.currentState!.removeItem(i, (context, animation) => const SizedBox());
        currentChildrenGlobalKeys.removeAt(i);
        currentChildrenKeys.removeAt(i);
        currentChildren.removeAt(i);
        updated = true;
      }
    }
    //Add
    for(int i=0;i<widget.childrenKeys!.length;i++){
      if(currentChildrenKeys.length<=i || widget.childrenKeys![i]!=currentChildrenKeys[i]){
        _listViewKey.currentState!.insertItem(i);
        currentChildrenGlobalKeys.insert(i,GlobalKey());
        currentChildrenKeys.insert(i,widget.childrenKeys![i]);
        currentChildren.insert(i,widget.children[i]);
        updated = true;
      }
    }
    if(updated){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _showNewWidgets(checkFromFirstIndex:true);
      });
    }
  }



  _showNewWidgets({bool checkFromFirstIndex = false}){



    List<T> newShownChildren = [];



    EdgesCoordinates? listViewEdges = getEdgesFromKey(_listViewKey,modifyPositionScalingByParentScale: widget.parentScale);
    if(listViewEdges==null){
      return;
    }

    bool start = false;


    int i;
    if(checkFromFirstIndex){
      i = 0;
    }else{
      i = currentStartAppearedWidgetIndex-10;
      i = i<0?0:i;
    }




    for(i;i<currentChildrenGlobalKeys.length;i++){

      EdgesCoordinates? childEdges = getEdgesFromKey(currentChildrenGlobalKeys[i],modifyPositionScalingByParentScale: widget.parentScale);

      if(childEdges!=null){
        T key = currentChildrenKeys[i];
        if((listViewEdges.top < childEdges.top && listViewEdges.bottom > childEdges.top) || (listViewEdges.top < childEdges.bottom && listViewEdges.bottom > childEdges.bottom)){
          if(!start){
            currentStartAppearedWidgetIndex = i;
          }
          start = true;
          newShownChildren.add(key);
          if(!shownChildren.contains(key)){
            widget.onShown(key);
          }
        }else{
          if(shownChildren.contains(key) && widget.onHidden!=null){
            widget.onHidden!(key);
          }
          if(start){
            break;
          }
        }
      }
    }
    shownChildren = newShownChildren;
  }

  _initializedChildrenWithKeysAndWidgetsKeys(){
    currentChildren = widget.children;
    currentChildrenKeys = (widget.childrenKeys!=null?
    widget.childrenKeys!:List.generate(currentChildren.length, (index) => index as T));
    currentChildrenGlobalKeys = List.generate(currentChildren.length, (_)=>GlobalKey());



  }

  @override
  void initState() {
    super.initState();

    _initializedChildrenWithKeysAndWidgetsKeys();


    _attachedController.addListener((){
      _showNewWidgets();
    });



    WidgetsBinding.instance.addPostFrameCallback((_){
      List<T> newShownChildren = [];
      EdgesCoordinates? listViewEdges = getEdgesFromKey(_listViewKey,modifyPositionScalingByParentScale: widget.parentScale);
      if(listViewEdges==null){
        return;
      }
      if (kDebugMode) {
        print("listViewEdges: ${listViewEdges.top}--${listViewEdges.bottom}");
      }
      for(int i=0;i<currentChildren.length;i++){
        EdgesCoordinates? childEdges = getEdgesFromKey(currentChildrenGlobalKeys[i],modifyPositionScalingByParentScale: widget.parentScale);
        if(childEdges!=null){
          if((listViewEdges.top < childEdges.top && listViewEdges.bottom > childEdges.top)||(listViewEdges.top < childEdges.bottom && listViewEdges.bottom > childEdges.bottom)){
            newShownChildren.add(currentChildrenKeys[i]);
          }
        }
      }

      shownChildren = newShownChildren;

      if(currentChildrenGlobalKeys.length==1){
        shownChildren =[currentChildrenKeys[0]] ;
        widget.onShown(currentChildrenKeys[0]);
      }

      widget.initShown(shownChildren);
    });
  }

  @override
  void dispose() {
    _attachedController.removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.childrenKeys!=null){
      _updateChildren();
    }

    return AnimatedList(
      key: _listViewKey,
      shrinkWrap: widget.shrink,
      physics: widget.physics??const BouncingScrollPhysics(),
      padding: widget.padding,
      controller: _attachedController,
      initialItemCount: widget.children.length,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        return SizedBox(
            key: currentChildrenGlobalKeys[index],
            child: widget.children[index]
        );
      }
    );
  }
}




// class _InteractiveListViewChild extends StatefulWidget {
//
//   const _InteractiveListViewChild({
//     Key? key,
//     required this.child
//   }) : super(key: key);
//
//   final Widget child;
//
//
//   @override
//   createState() => _InteractiveListViewChildState();
// }
//
// class _InteractiveListViewChildState extends State<_InteractiveListViewChild>{
//
//   final GlobalKey _key = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _key.currentContext.
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context,boxConstraints){
//         boxConstraints.
//         return widget.child;
//       },
//     );
//   }
// }