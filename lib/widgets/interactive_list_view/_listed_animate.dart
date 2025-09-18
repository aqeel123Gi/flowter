part of 'interactive_list_view.dart';

class ListedAnimate extends StatelessWidget with EmbeddedAnimate{

  ListedAnimate({
    super.key,
    required String id,
    required this.child
  }){
    animateController.setIDIfNull(id);
  }

  final Widget child;

  @override
  Widget build(BuildContext context) => Animate(
    controller: animateController,
    startFrom: TransformData(y: 30, duration: const Duration(milliseconds: 700)),
    endTo: TransformData(y: 30, duration: const Duration(milliseconds: 0)),
    child: child
  );

}