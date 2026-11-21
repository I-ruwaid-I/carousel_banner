# carousel_banner

A swipeable, infinitely looping banner carousel for Flutter with card scaling, call-to-action buttons, badges, custom arrow positioning, and Netflix-style hero card expansions.

Each slide **must** provide a title, subtitle, and background (either color or image) anchored to the bottom over a subtle readability gradient scrim.

## Features

- **Infinitely Looping**: Last slide wraps seamlessly back to the first.
- **Backgrounds**: Solid/Gradient color (`CarouselColorBackground`) or Image (`CarouselImageBackground`).
- **3D Card Peeking & Scaling**: `viewportFraction` peeking with `enlargeCenterPage` scaling effect.
- **Badges & Action Buttons**: Top-left promo chips (`badgeText`, `badgeColor`) and bottom-right Call-To-Action buttons (`ctaText`, `onCtaTap`).
- **Netflix-Style Card Expansion**: Built-in Hero animation support (`enableHero`, `heroTag`) with `CarouselDetailPage`.
- **Flexible Navigation Arrows**: Position arrows anywhere (`arrowAlignment`) or overlay directly on top of the slide card (`arrowsOnSlide: true`).
- **Responsive Aspect Ratio**: Scale heights dynamically across screen sizes using `aspectRatio: 16 / 9`.
- **Autoplay & Touch Controls**: Active dot progress indicator, swipe/touch pause, and keyboard navigation.

## Getting started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  carousel_banner: ^0.1.3
```

## Usage

> **Note**: In Flutter 3.22+, hide Flutter's built-in `CarouselController` when importing `material.dart` if using `CarouselController`:
> `import 'package:flutter/material.dart' hide CarouselController;`

```dart
import 'package:carousel_banner/carousel_banner.dart';
import 'package:flutter/material.dart' hide CarouselController;

BannerCarousel(
  autoplay: true,
  viewportFraction: 0.88,
  enlargeCenterPage: true,
  items: [
    CarouselItem(
      id: '1',
      title: 'Summer Flash Sale',
      subtitle: 'Up to 50% discount on selected items.',
      badgeText: '50% OFF',
      badgeColor: Colors.deepOrange,
      ctaText: 'Shop Now',
      background: const CarouselColorBackground(Color(0xFF3B2F63)),
      onCtaTap: () => print('CTA tapped!'),
    ),
    CarouselItem(
      id: '2',
      title: 'Forest Adventure',
      subtitle: 'Sustainable gear for outdoor enthusiasts.',
      background: const CarouselImageBackground(
        NetworkImage('https://example.com/forest.png'),
      ),
    ),
  ],
  interval: const Duration(seconds: 4),
  onTap: (item) => print('Tapped ${item.title}'),
)
```

### Netflix-Style Card-to-Page Expansion

When a slide is tapped, seamlessly expand it into a full-screen detail page using `CarouselDetailPage`:

```dart
BannerCarousel(
  items: items,
  onTap: (item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CarouselDetailPage(
          item: item,
          actionButtons: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Trailer'),
            ),
          ],
          body: const Text('Detailed description and metadata goes here...'),
        ),
      ),
    );
  },
)
```

### Custom Navigation Arrow Positioning

Position arrows on top of the slide card or customize alignment:

```dart
BannerCarousel(
  items: items,
  showArrows: true,
  arrowsOnSlide: true, // Overlays arrows directly inside the slide card
  arrowAlignment: Alignment.center, // Alignment.topCenter, Alignment.bottomCenter
)
```

### Responsive Aspect Ratio

Instead of hardcoded heights, set an aspect ratio to scale dynamically:

```dart
BannerCarousel(
  aspectRatio: 16 / 9,
  items: items,
)
```

### Custom Overlay

By default, text sits over a bottom gradient scrim. Pass a custom `BoxDecoration` to customize it:

```dart
BannerCarousel(
  items: items,
  overlay: BoxDecoration(
    color: Colors.black.withValues(alpha: 0.35),
  ),
)
```

## Parameter Reference

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `items` | `List<CarouselItem>` | **Required** | List of slides in the carousel. |
| `height` | `double` | `230` | Fixed height of the carousel (when `aspectRatio` is null). |
| `aspectRatio` | `double?` | `null` | Dynamic width/height ratio (e.g. `16 / 9`). |
| `viewportFraction` | `double` | `1.0` | Viewport fraction per page (e.g. `0.85` for peeking). |
| `enlargeCenterPage` | `bool` | `false` | Scales active center slide up for 3D depth effect. |
| `autoplay` | `bool` | `false` | Enables automatic slide transitions. |
| `interval` | `Duration` | `4s` | Duration spent on each slide during autoplay. |
| `showArrows` | `bool` | `false` | Whether to display side navigation arrows. |
| `arrowsOnSlide` | `bool` | `false` | Overlays arrows directly on top of the slide card. |
| `arrowAlignment` | `AlignmentGeometry` | `Alignment.center` | Vertical alignment of navigation arrows. |
| `enableHero` | `bool` | `true` | Wraps slides in `Hero` widgets for card transitions. |
| `showDots` | `bool` | `true` | Displays bottom indicator dots with progress animation. |
| `onTap` | `ValueChanged<CarouselItem>?` | `null` | Callback fired when a slide is tapped. |

See the [example](example/lib/main.dart) for a runnable Flutter application.

## Additional Information

Contributions are welcome! Please open issues or pull requests on the repository.
