import 'package:flutter/material.dart';

class StackTap extends StatefulWidget {
  const StackTap({
    Key? key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.splashColor,
  }) : super(key: key);

  final Widget child;
  final Function() onTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;

  @override
  _StackTapState createState() => _StackTapState();
}

class _StackTapState extends State<StackTap> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: new Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: widget.borderRadius,
              onTap: widget.onTap,
              hoverColor: Colors.white.withOpacity(0.3),
              splashColor: widget.splashColor != null
                  ? widget.splashColor
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}
