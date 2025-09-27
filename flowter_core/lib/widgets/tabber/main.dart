import 'package:flutter/material.dart';
import '../../classes/button_data.dart';



class Tabs extends StatefulWidget {


  const Tabs({
    super.key,
    required this.currentIndex,
    required this.onPressed,
    required this.buttonsData,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderRadius = 100,
    this.padding = 5,
    this.shadow
  });


  final int? currentIndex;
  final void Function(int index) onPressed;
  final List<ButtonData> buttonsData;
  final Color foregroundColor;
  final Color backgroundColor;
  final double borderRadius;
  final double padding;
  final BoxShadow? shadow;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {


  @override
  Widget build(BuildContext context) {

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // boxShadow: [widget.shadow??shadow()[0]]
      ),
      child: Padding(padding: EdgeInsets.all(widget.padding),child:LayoutBuilder(builder: (context,c)
    {
    double width = c.maxWidth;

    return Stack(children: [
          AnimatedPositionedDirectional(
            curve: Curves.easeOutQuad,
              width: width/widget.buttonsData.length,
              start:widget.currentIndex!=null?
                widget.currentIndex!*(width/widget.buttonsData.length):
                  0,
              top: 0,
              bottom: 0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: widget.currentIndex!=null && widget.buttonsData[widget.currentIndex!].color!=null?widget.buttonsData[widget.currentIndex!].color:widget.foregroundColor.withValues(alpha:widget.currentIndex==null?0:1),
                    borderRadius: BorderRadius.circular(widget.borderRadius-widget.padding),
                  ))
          ),
        Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.buttonsData.length, (index) =>
                        TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: Size(width/widget.buttonsData.length,41),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius-widget.padding)),
                            foregroundColor: widget.currentIndex == index ? widget.backgroundColor : (widget.buttonsData[index].color??widget.foregroundColor)
                          ),
                            onPressed: (){
                              widget.onPressed(index);
                            },
                            child:Center(child:widget.buttonsData[index].iconData!=null?Icon(
                              widget.buttonsData[index].iconData!,
                              color: widget.currentIndex == index ? widget.backgroundColor : (widget.buttonsData[index].color??widget.foregroundColor),
                              size: 25,
                              ):widget.buttonsData[index].title!=null?Text(
                            widget.buttonsData[index].title!,
                            style: const TextStyle(
                            fontWeight: FontWeight.normal)):
                    throw Exception("No Icon Or Title in ButtonData")
                ))))

      ]);})));
  }
}
