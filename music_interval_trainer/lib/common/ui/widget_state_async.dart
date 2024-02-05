import 'dart:math';

import 'package:flutter/material.dart';

abstract class WidgetStateAsync<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeData(),
      builder: (context, snapshot) => (!snapshot.hasData ? _buildLoaderWidget() : doBuild(context)),
    );
  }

  @override
  void initState() {
    super.initState();
    doInitializeData();
  }

  @protected
  Widget doBuild(BuildContext context);

  @protected
  Future<void> doInitializeData();

  @protected
  void onDataInitialized() {
    // Do nothing so far
  }

  Widget _buildLoaderWidget() {
    Size size = MediaQuery.of(context).size;

    double radius = min(
      (size.height / 3),
      (size.width / 3),
    );

    return Stack(
      children: [
        Opacity(
          opacity: 0.5, // Prevents interaction with background buttons
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.black,
          ),
        ),
        Opacity(
          opacity: 0.75,
          child: Center(
            child: SizedBox(
              height: radius,
              width: radius,
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _initializeData() async {
    await doInitializeData();
    onDataInitialized();

    return true;
  }
}
