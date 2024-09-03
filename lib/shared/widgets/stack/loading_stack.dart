import 'package:app/models/loading_indicator_model.dart';
import 'package:app/shared/widgets/loading_indicator/stream_circle_loading_indicator.dart';
import 'package:flutter/material.dart';

class LoadingStack extends StatelessWidget {
  final Widget child;
  final Stream<LoadingIndicatorModel> showLoadingIndicatorStream;
  final Color backgroundColor;
  final bool positionedFillChild;
  final AlignmentGeometry alignment;

  const LoadingStack({
    super.key,
    required this.child,
    required this.showLoadingIndicatorStream,
    this.backgroundColor = Colors.transparent,
    this.positionedFillChild = false,
    this.alignment = AlignmentDirectional.topStart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        positionedFillChild ? Positioned.fill(child: child) : child,
        Positioned.fill(
          child: StreamCircleLoadingIndicator(
            showLoadingIndicatorStream: showLoadingIndicatorStream,
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }
}
