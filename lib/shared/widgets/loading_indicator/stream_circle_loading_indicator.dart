import 'package:app/core/bloc_provider.dart';
import 'package:app/models/loading_indicator_model.dart';
import 'package:app/shared/widgets/loading_indicator/circle_loading_indicator.dart';
import 'package:flutter/material.dart';

class StreamCircleLoadingIndicator extends StatelessWidget {
  final Stream<LoadingIndicatorModel> showLoadingIndicatorStream;
  final Color? backgroundColor;

  const StreamCircleLoadingIndicator({
    super.key,
    required this.showLoadingIndicatorStream,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingIndicatorModel>(
      stream: showLoadingIndicatorStream,
      builder: (context, config) {
        return config.showLoading
            ? Container(
                color: config.enableLoadingBackground
                    ? backgroundColor
                    : Colors.transparent,
                child: const AbsorbPointer(
                  child: Center(
                    child: CircleLoadingIndicator.blue(),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
