import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SDIcon extends StatelessWidget {

  const SDIcon({
    super.key,
    this.iconData,
    this.svgAssetPath,
    this.color,
    this.size,
    this.invertedHorizontally = false,
    this.invertedVertically = false,
    this.invertedWithRtlTextDirection = false,
    this.alignment = Alignment.center

  });

  final String? svgAssetPath;
  final IconData? iconData;
  final Color? color;
  final double? size;
  final bool invertedWithRtlTextDirection;
  final bool invertedHorizontally;
  final bool invertedVertically;
  final AlignmentGeometry alignment;

  SDIcon withParams({Color? color, double? size, AlignmentGeometry? alignment, bool? invertedWithRtlTextDirection}){
    return SDIcon(
        key:key,
        iconData: iconData,
        svgAssetPath: svgAssetPath,
        color: color??this.color,
        size: size??this.size,
        invertedHorizontally: invertedHorizontally,
        invertedVertically: invertedVertically,
        invertedWithRtlTextDirection: invertedWithRtlTextDirection??this.invertedWithRtlTextDirection,
        alignment: alignment??this.alignment
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.scale(
        scaleX: (Directionality.of(context) == TextDirection.rtl && invertedWithRtlTextDirection ? -1 : 1) * (invertedHorizontally ? -1 : 1),
        scaleY: invertedVertically ? -1 : 1,
        child: Builder(builder: (_){
          if(iconData != null && svgAssetPath != null){
            throw Exception("Choose one of iconData or svgAssetPath");
          }
          if(iconData != null){
            return Icon(iconData, color: color, size: size);
          }
          if(svgAssetPath != null){
            return SvgPicture.asset(svgAssetPath!, width: size, height: size , theme: color == null ? null : SvgTheme(currentColor: color!), colorFilter: color == null ? null :ColorFilter.mode(color!, BlendMode.srcIn));
          }
          throw Exception("Choose one of iconData or svgAssetPath");
        }),
      ),
    );
  }
}
