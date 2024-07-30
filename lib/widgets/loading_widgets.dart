import 'package:flutter/material.dart';

import '../utils/constant_data.dart';

class LoadingWidgets {
  static showLoading(BuildContext context, {bool? canPop}) {
    return showDialog(
        useSafeArea: false,
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return PopScope(
            canPop: canPop ?? false,
            child: Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CircularProgressIndicator(
                  color: ColorTheme.primaryColor,
                ),
              ),
            ),
          );
        });
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        animation: CurvedAnimation(
          parent: Scaffold.of(context).appBarMaxHeight == 0
              ? const AlwaysStoppedAnimation(0)
              : ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        )));
  }
}
