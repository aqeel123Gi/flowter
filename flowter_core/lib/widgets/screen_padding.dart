import 'package:flutter/cupertino.dart';

EdgeInsets screenPadding (BuildContext context)=>EdgeInsets.only(
    top: MediaQuery.of(context).padding.top,
    bottom: MediaQuery.of(context).padding.bottom,
    // left: MediaQuery.of(context).padding.left,
    // right: MediaQuery.of(context).padding.right
);