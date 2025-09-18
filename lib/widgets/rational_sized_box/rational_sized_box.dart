import 'package:flutter/material.dart';

class RationalSizedBox extends StatelessWidget {
  const RationalSizedBox({super.key, required this.maxSize, required this.child});

  final Size maxSize;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        double percentage;
        Size size;

        if(constraints.maxHeight>maxSize.height && constraints.maxWidth>maxSize.width){
          percentage = 1;
        }
        else if(constraints.maxHeight<maxSize.height && constraints.maxWidth<maxSize.width){
          if(maxSize.height-constraints.maxHeight > maxSize.width-constraints.maxWidth){
            percentage = constraints.maxHeight/maxSize.height;
          }else{
            percentage = constraints.maxWidth/maxSize.width;
          }
        }
        else if(constraints.maxHeight>maxSize.height && constraints.maxWidth<maxSize.width){
          percentage = constraints.maxWidth/maxSize.width;
        }
        else{
          percentage = constraints.maxHeight/maxSize.height;
        }


        size = maxSize*percentage;

        return SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        );
      },
    );
  }
}