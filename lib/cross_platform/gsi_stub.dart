import 'package:flutter/material.dart';

class GSIButtonConfiguration {
  final dynamic size;
  final dynamic shape;
  final double? minimumWidth;

  const GSIButtonConfiguration({this.size, this.shape, this.minimumWidth});
}

class GSIButtonSize {
  static const large = null;
}

class GSIButtonShape {
  static const pill = null;
}

Widget renderButton({GSIButtonConfiguration? configuration}) {
  return const SizedBox.shrink();
}