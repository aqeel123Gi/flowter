part of 'template.dart';


class TemplateCustomization{

  final double Function()? scaleFrom;
  final Widget Function(BuildContext context, List<TemplateData<Widget>> list) builder;
  final double Function(BuildContext context, TemplateData templateData) topPadding;
  final double Function(BuildContext context, TemplateData templateData) bottomPadding;
  final TemplateData Function() initTemplateData;


  TemplateCustomization({
    this.scaleFrom,
    required this.builder,
    required this.topPadding,
    required this.bottomPadding,
    required this.initTemplateData,
  });

}