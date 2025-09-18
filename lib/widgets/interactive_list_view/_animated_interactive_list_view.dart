part of 'interactive_list_view.dart';

class AnimatedInteractiveListView<T> extends StatefulWidget {
   const AnimatedInteractiveListView({
    super.key,
    required this.milliseconds,
    this.shrink = true,
    this.animateID,
    this.padding,
    this.physics,
    this.childrenKeys,
    required this.children,
    this.controller
  });

   final int milliseconds;
  final ScrollController? controller;
  final String? animateID;
  final bool shrink;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final List<T>? childrenKeys;
  final List<Widget> children;


  @override
  State<AnimatedInteractiveListView<T>> createState() => _AnimatedInteractiveListViewState<T>();
}

class _AnimatedInteractiveListViewState<T> extends State<AnimatedInteractiveListView<T>> {

  late String baseID;


  @override
  void initState() {
    baseID = widget.animateID??Generator.getKey();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return InteractiveListView<T>(
      controller: widget.controller,
      shrink:widget.shrink,
      onShown: (index){
        AnimateController.showByID("$baseID$index");
      },
      onHidden: (index){
        AnimateController.hideByID("$baseID$index");
      },
      physics: widget.physics,
      padding: widget.padding,
      initShown: (list) {
        AnimateController.startOneByOneByID(baseID, list, widget.milliseconds);
      },
      childrenKeys: widget.childrenKeys,
      children: List.generate(widget.children.length,(index) {
        Widget child = widget.children[index];
        if (child is EmbeddedAnimate) {

          EmbeddedAnimate embeddedAnimateChild = child as EmbeddedAnimate;

          embeddedAnimateChild.animateController.setIDIfNull("$baseID${widget.childrenKeys != null? widget.childrenKeys![index]: index}");

        } else {

          // TODO: Fix it
          // child
          // child = ListedAnimate(
          //     id: "$baseID${widget.childrenKeys != null ? widget.childrenKeys![index] : index}",
          //     child: child
          // );

        }
        return child;
      }));
  }


}