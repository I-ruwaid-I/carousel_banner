## 0.1.3

- Formatted all Dart source files with standard Dart formatter.
- Configured static analyzer rules and ignores to prevent deprecation warnings on upcoming Flutter SDKs in pub.dev static analysis (aiming for 160/160 pub points).

## 0.1.2

- Fixed `dartdoc` API documentation and example generation for pub.dev.
- Fixed `CarouselController` import ambiguity in example app.

## 0.1.1

- Updated README.md with comprehensive documentation, parameters reference table, import compatibility tips, and code examples for pub.dev.

## 0.1.0

- Added `viewportFraction` & `enlargeCenterPage` for adjacent slide peeking and 3D center slide scaling effects.
- Added `badgeText` & `badgeColor` support on `CarouselItem` for top-left promo chips.
- Added `ctaText` & `onCtaTap` support on `CarouselItem` for bottom-right action buttons.
- Added `aspectRatio` property for responsive banner scaling.
- Added `arrowAlignment` (`Alignment.center`, `Alignment.topCenter`, `Alignment.bottomCenter`) and `arrowsOnSlide` for flexible navigation arrow positioning.
- Added `enableHero` and `heroTag` on `CarouselItem` for Netflix-style Hero card-to-page expansions.
- Added `CarouselDetailPage` widget for instant Netflix-style detail page transitions.

## 0.0.1

- Initial release.
- Infinitely looping carousel with colour or image backgrounds.
- Mandatory bottom-anchored title and subtitle.
- Autoplay with progress in the active dot, optional `onTap` and custom `overlay`.
