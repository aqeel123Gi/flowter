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


  EdgeInsets withWindowTopPadding(BuildContext context) {
    return EdgeInsets.only(
        top: top + Window.topPadding(context),
        left: left,
        right: right,
        bottom: bottom
    );
  }


  EdgeInsets withTopBottomWindowPadding(BuildContext context) {
    return EdgeInsets.only(
        top: top + Window.topPadding(context),
        left: left,
        right: right,
        bottom: bottom + Window.bottomPadding(context)
    );
  }



}