import 'package:flutter/material.dart';

class CachedImageWidget extends StatefulWidget {
  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.contain,
    this.errorWidget,
    this.padding = 0.0,
  });

  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final Widget? errorWidget;
  final double padding;

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      fit: widget.fit,
      height: widget.height,
      width: widget.width,
      errorBuilder:
          (context, error, stackTrace) =>
              widget.errorWidget ??
              Container(
                // padding: EdgeInsets.all(widget.padding),
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png'),
              ),
    );
  }
}
