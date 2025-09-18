part of 'auto_scale_builder.dart';

class AutoScaleBuilderController extends WidgetController<AutoScaleBuilder>{



  void shouldBeFiniteLayoutBox(BoxConstraints constraints) {

    if(!constraints.hasBoundedHeight && widget.maxHeightConstraint==double.infinity && !constraints.hasBoundedWidth && widget.maxWidthConstraint==double.infinity) {
      throw Exception("AutoScaleBuilder must have a finite size.");
    }

  }



  bool finiteHeightLayoutBox(BoxConstraints constraints) {
    return constraints.hasBoundedHeight || widget.maxHeightConstraint<double.infinity;
  }

  bool finiteWidthLayoutBox(BoxConstraints constraints) {
    return constraints.hasBoundedWidth || widget.maxWidthConstraint<double.infinity;
  }





  double maxScaleCalculation(double heightConstraint, double widthConstraint) {

    double scaleByWidth = scaleCalculationByWidth(widthConstraint);
    double scaleByHeight = scaleCalculationByHeight(heightConstraint);

    double boundedScaleByLayout = scaleByWidth > scaleByHeight ? scaleByHeight : scaleByWidth;

    return min(boundedScaleByLayout, widget.maxScale);

  }





  double scaleCalculationByWidth(double layoutWidth) {
    return layoutWidth/widget.contentSize.width;
  }


  double scaleCalculationByHeight(double layoutHeight) {
    return layoutHeight/widget.contentSize.height;
  }






}