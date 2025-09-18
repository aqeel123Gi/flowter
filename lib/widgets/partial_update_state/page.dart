import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'controller.dart';


TemplateData xTD()=>TemplateData(
  id: "PLACE HOLDER",
  bottomPadding_: false,
    body: const XPage(),
);



class XPage extends StatefulWidget{
  const XPage({
    super.key
  });

  @override
  State<XPage> createState() => _XPageState();
}

class _XPageState extends State<XPage> {

  final XPageController _controller = XPageController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<XPageController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          return const Placeholder();
        }
    );
  }


}













