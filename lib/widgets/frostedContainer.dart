import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';

class FrostedContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color color;
  final Function onTap;
  final bool noEdgesOnRight;

  FrostedContainer({
    @required this.child,
    @required this.borderRadius,
    @required this.padding,
    @required this.color,
    @required this.onTap,
    @required this.noEdgesOnRight,
  });

  @override
  _FrostedContainerState createState() => _FrostedContainerState();
}

class _FrostedContainerState extends State<FrostedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius:
            widget.noEdgesOnRight == false || widget.noEdgesOnRight == null
                ? BorderRadius.circular(widget.borderRadius)
                : BorderRadius.only(
                    topLeft: Radius.circular(widget.borderRadius),
                    bottomLeft: Radius.circular(widget.borderRadius)),
        child: Container(
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: GestureDetector(
              onTap: widget.onTap != null ? widget.onTap : null,
              child: new Container(
                padding: widget.padding,
                color: widget.color == null
                    ? Color(0xff382350).withOpacity(0.7)
                    : widget.color.withOpacity(0.3),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FrostedBoxButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final double size;

  FrostedBoxButton({this.icon, this.onPressed, this.size});

  @override
  Widget build(BuildContext context) {
    double iconSize = size != null ? size : 30;

    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.15,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: FrostedContainer(
          child: Center(
            child: IconButton(
              alignment: Alignment.center,
              icon: FaIcon(
                icon,
                size: iconSize,
                color: Colors.white,
              ),
              onPressed: onPressed,
            ),
          ),
          borderRadius: 10,
        ),
      ),
    );
  }
}
