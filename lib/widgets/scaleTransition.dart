import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class MyScaleTransition extends StatefulWidget {
  _MyScaleTransitionState createState() => _MyScaleTransitionState();

  final Widget child;
  MyScaleTransition({this.child});
}

class _MyScaleTransitionState extends State<MyScaleTransition>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3250),
      vsync: this,
      value: 0.1,
    );
    _animation = Tween<double>(begin: 1, end: 0.92)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.forward();
    _controller.repeat(reverse: true);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: _animation,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
