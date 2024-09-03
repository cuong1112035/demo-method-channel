import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  T bloc<T extends BlocBase>() {
    return BlocProvider.of<T>(this);
  }
}

typedef BlocCreateFunction<T> = T Function(BuildContext context);

abstract class BlocBase {
  bool isDisposed = false;

  @mustCallSuper
  void dispose() {
    isDisposed = true;
  }
}

class BlocsProvider extends StatelessWidget {
  final Widget child;
  final List<BlocBase> blocs;

  const BlocsProvider({
    super.key,
    required this.child,
    required this.blocs,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    for (final bloc in blocs) {
      result = BlocProvider(create: (context) => bloc, child: result);
    }
    return result;
  }
}

// ignore: must_be_immutable
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  late T bloc;
  BlocCreateFunction<T>? create;
  final bool usingBlocValue;

  BlocProvider({
    super.key,
    required this.create,
    required this.child,
  }) : usingBlocValue = false;

  BlocProvider.value({
    super.key,
    required this.bloc,
    required this.child,
  }) : usingBlocValue = true;

  @override
  State<BlocProvider> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final blocProviderInherited = context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()
        ?.widget as _BlocProviderInherited<T>;
    return blocProviderInherited.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  late T bloc;

  @override
  void initState() {
    super.initState();
    if (widget.create != null) {
      bloc = widget.create!(context);
    } else {
      bloc = widget.bloc;
    }
  }

  @override
  void dispose() {
    if (widget.usingBlocValue == false) {
      bloc.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BlocProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.usingBlocValue) {
      bloc = widget.bloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      bloc: bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  const _BlocProviderInherited({
    super.key,
    required super.child,
    required this.bloc,
  });

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}

class BlocBuilder<S> extends StatelessWidget {
  final S? initialData;
  final Stream<S> stream;
  final Widget Function(BuildContext context, S value) builder;
  final Widget placeholder;

  const BlocBuilder({
    super.key,
    this.initialData,
    required this.stream,
    required this.builder,
    this.placeholder = const SizedBox(),
  });

  const BlocBuilder.sliver({
    super.key,
    this.initialData,
    required this.stream,
    required this.builder,
  }) : placeholder = const SliverToBoxAdapter();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return builder(context, snapshot.data as S);
          default:
            return placeholder;
        }
      },
    );
  }
}
