part of persistent_bottom_nav_bar_v2;

class NavBarEssentials {
  final int? selectedIndex;
  final int? previousIndex;
  final Color? backgroundColor;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;
  final double? navBarHeight;
  final NavBarPadding? padding;
  final bool? popScreensOnTapOfSelectedTab;
  final ItemAnimationProperties? itemAnimationProperties;
  final BuildContext? selectedScreenBuildContext;

  const NavBarEssentials({
    this.selectedIndex,
    this.previousIndex,
    this.backgroundColor,
    required this.items,
    this.onItemSelected,
    this.navBarHeight = 0.0,
    this.padding,
    this.popScreensOnTapOfSelectedTab,
    this.itemAnimationProperties,
    this.selectedScreenBuildContext,
  });

  NavBarEssentials copyWith({
    int? selectedIndex,
    int? previousIndex,
    Color? backgroundColor,
    List<PersistentBottomNavBarItem>? items,
    ValueChanged<int>? onItemSelected,
    double? navBarHeight,
    NavBarPadding? padding,
    bool? popScreensOnTapOfSelectedTab,
    ItemAnimationProperties? itemAnimationProperties,
  }) {
    return NavBarEssentials(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      previousIndex: previousIndex ?? this.previousIndex,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      items: items ?? this.items,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      navBarHeight: navBarHeight ?? this.navBarHeight,
      padding: padding ?? this.padding,
      popScreensOnTapOfSelectedTab:
          popScreensOnTapOfSelectedTab ?? this.popScreensOnTapOfSelectedTab,
      itemAnimationProperties:
          itemAnimationProperties ?? this.itemAnimationProperties,
    );
  }
}
