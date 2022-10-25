import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

void main() {
  test('NavBarPadding.fromLTRB assigns sides correctly', () {
    final NavBarPadding padding = NavBarPadding.fromLTRB(5.0, 7.0, 11.0, 13.0);

    expect(padding.left, 5.0);
    expect(padding.top, 7.0);
    expect(padding.right, 11.0);
    expect(padding.bottom, 13.0);
  });

  test('NavBarPadding.symmetric assigns sides correctly', () {
    final NavBarPadding padding =
        NavBarPadding.symmetric(horizontal: 5.0, vertical: 7.0);

    expect(padding.left, 5.0);
    expect(padding.top, 7.0);
    expect(padding.right, 5.0);
    expect(padding.bottom, 7.0);
  });

  test('NavBarPadding.all assigns sides correctly', () {
    final NavBarPadding padding = NavBarPadding.all(5.0);

    expect(padding.left, 5.0);
    expect(padding.top, 5.0);
    expect(padding.right, 5.0);
    expect(padding.bottom, 5.0);
  });

  test('NavBarPadding.only assigns sides correctly', () {
    final NavBarPadding padding = NavBarPadding.only(
      left: 5.0,
      top: 7.0,
      right: 11.0,
      bottom: 13.0,
    );

    expect(padding.left, 5.0);
    expect(padding.top, 7.0);
    expect(padding.right, 11.0);
    expect(padding.bottom, 13.0);
  });
}
