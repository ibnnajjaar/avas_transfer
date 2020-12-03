import 'package:flutter/material.dart';

class ScaleIn extends StatefulWidget {
  final Widget child;

  ScaleIn({this.child});

  @override
  _ScaleInState createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      value: 0.1,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

    _controller.forward(from: 0.45);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
