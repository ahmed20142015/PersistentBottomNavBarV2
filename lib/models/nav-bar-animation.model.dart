part of persistent_bottom_nav_bar_v2;

class ScreenTransitionAnimation {
  final bool animateTabTransition;
  final Duration duration;
  final Curve curve;

  const ScreenTransitionAnimation({
    this.animateTabTransition = false,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });
}

class ItemAnimationProperties {
  final Duration? duration;
  final Curve? curve;

  const ItemAnimationProperties({
    this.duration,
    this.curve,
  });
}
