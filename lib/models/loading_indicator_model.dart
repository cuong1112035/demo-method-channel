class LoadingIndicatorModel {
  final bool showLoading;
  final bool enableLoadingBackground;

  LoadingIndicatorModel.show({
    this.enableLoadingBackground = false,
  }) : showLoading = true;

  LoadingIndicatorModel.hide()
      : showLoading = false,
        enableLoadingBackground = false;
}
