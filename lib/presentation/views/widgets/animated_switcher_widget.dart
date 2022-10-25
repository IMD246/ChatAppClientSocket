import 'package:flutter/cupertino.dart';

class AnimatedSwitcherWidget extends StatelessWidget {
  const AnimatedSwitcherWidget(
      {super.key, this.duration, required this.widget});
  final Duration? duration;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      key: key,
      duration: duration ?? const Duration(milliseconds: 250),
      switchOutCurve: const Threshold(0),
      child: widget,
    );
  }
}
