import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogController extends GetxController {
  String text = "";
}

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<ProgressDialogController>(
        init: ProgressDialogController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 15),
                if (controller.text.isNotEmpty)
                  Text(
                    controller.text,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
