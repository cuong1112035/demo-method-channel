import 'package:app/core/bloc_provider.dart';
import 'package:app/features/demo_bloc.dart';
import 'package:app/shared/widgets/stack/loading_stack.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late final bloc = context.bloc<DemoBloc>();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: bloc.globalKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(runtimeType.toString()),
        ),
        body: LoadingStack(
          showLoadingIndicatorStream: bloc.showLoadingIndicatorBehaviorSubject,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FilledButton(
                    onPressed: bloc.onTapCaptureScreenWithDartButton,
                    child: const Text('Capture screen with Dart'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: bloc.onTapCaptureScreenWithSwiftButton,
                    child: const Text('Capture screen with IOS/MACOS'),
                  ),
                  const SizedBox(height: 30),
                  const Text('Results:'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.red,
                          width: 300,
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          child: BlocBuilder(
                            stream: bloc.dartCapturedImageBehaviorSubject,
                            builder: (context, capturedImage) {
                              return capturedImage;
                            },
                          ),
                        ),
                        Container(
                          color: Colors.green,
                          width: 300,
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          child: BlocBuilder(
                            stream: bloc.swiftCapturedImageBehaviorSubject,
                            builder: (context, capturedImage) {
                              return capturedImage;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
