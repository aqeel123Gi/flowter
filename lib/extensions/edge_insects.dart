part of 'extensions.dart';

extension EdgeInsectsFunctions on EdgeInsets {

  EdgeInsets withWindowBottomPadding(BuildContext context) {
    return EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom + Window.bottomPadding(context)
    );
  }

}