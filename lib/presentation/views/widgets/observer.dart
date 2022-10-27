import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  const Observer({
    super.key,
    this.onError,
    required this.onSuccess,
    required this.stream,
    this.onLoading,
  });
  final Stream<T> stream;
  final Function(BuildContext context, Object? error)? onError;
  final Function(BuildContext context, T? data) onSuccess;
  final Function? onLoading;
  Widget _defaultOnLoading() => const Center(
        child: CircularProgressIndicator(),
      );
  Widget _defaultOnError(context, error) => Center(
        child: Text(error.toString()),
      );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (onError != null) {
            return onError!(context, snapshot.error);
          } else {
            return _defaultOnError(context, snapshot.error);
          }
        }
        if (snapshot.hasData) {
          return onSuccess(context, snapshot.data);
        } else {
          if (onLoading != null) {
            return onLoading!(context);
          } else {
            return _defaultOnLoading();
          }
        }
      },
    );
  }
}
