

import 'package:flutter/widgets.dart';

import '../next.dart';
import '../nuvigator.dart';

/// Mixing to add Nuvigator support for custom Route.
mixin NuvigatorPageRoute<T> on PageRoute<T> {
  NuvigatorState? get nuvigator {
    if (navigator is NuvigatorState?) {
      return navigator as NuvigatorState?;
    }
    return null;
  }

  bool get isNested => nuvigator != null && nuvigator!.isNested;

  @override
  bool get fullscreenDialog {
    if (isNested && isFirst && ModalRoute.of(nuvigator!.context) is PageRoute) {
      final containedPageRoute = ModalRoute.of(nuvigator!.context) as PageRoute;
      return super.fullscreenDialog || containedPageRoute.fullscreenDialog;
    }
    return super.fullscreenDialog;
  }

  @override
  bool get canPop {
    return super.canPop || isNested;
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    final res = await super.willPop();
    if (res == RoutePopDisposition.bubble && isNested) {
      return RoutePopDisposition.pop;
    }
    return res;
  }
}

abstract class ScreenType {
  const ScreenType();

  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings? settings);
}
