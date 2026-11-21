// ignore_for_file: deprecated_member_use
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:carousel_banner/carousel_banner.dart';

void main() {
  final items = <CarouselItem>[
    CarouselItem(
      id: '1',
      title: 'Aurora',
      subtitle: 'Soft violet light over a dark horizon.',
      background: const CarouselColorBackground(Color(0xFF3B2F63)),
    ),
    CarouselItem(
      id: '2',
      title: 'Forest',
      subtitle: 'Green hues for organic products.',
      background: CarouselImageBackground(MemoryImage(kTransparentImage)),
    ),
  ];

  testWidgets('renders mandatory title and subtitle at the bottom', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BannerCarousel(items: items))),
    );

    expect(find.text('Aurora'), findsOneWidget);
    expect(find.text('Soft violet light over a dark horizon.'), findsOneWidget);
  });

  testWidgets('swipes between slides and updates dots', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BannerCarousel(items: items))),
    );

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Forest'), findsOneWidget);
  });

  testWidgets('loops from the last slide back to the first', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BannerCarousel(items: items))),
    );

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Aurora'), findsOneWidget);
  });

  testWidgets('calls onTap when a slide is tapped', (tester) async {
    final tapped = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarousel(
            items: items,
            onTap: (item) => tapped.add(item.id),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Aurora'));
    await tester.pumpAndSettle();

    expect(tapped, ['1']);
  });

  testWidgets('renders badgeText and ctaText on slide and triggers onCtaTap', (
    tester,
  ) async {
    bool ctaTapped = false;
    final itemWithBadgeAndCta = [
      CarouselItem(
        id: 'badge_1',
        title: 'Special Offer',
        subtitle: 'Get 50% discount on all items',
        badgeText: '50% OFF',
        ctaText: 'Claim Now',
        onCtaTap: () => ctaTapped = true,
        background: const CarouselColorBackground(Colors.purple),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BannerCarousel(items: itemWithBadgeAndCta)),
      ),
    );

    expect(find.text('50% OFF'), findsOneWidget);
    expect(find.text('Claim Now'), findsOneWidget);

    await tester.tap(find.text('Claim Now'));
    await tester.pumpAndSettle();

    expect(ctaTapped, isTrue);
  });

  testWidgets('supports viewportFraction, enlargeCenterPage and aspectRatio', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarousel(
            items: items,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );

    expect(find.byType(AspectRatio), findsOneWidget);
    expect(find.byType(BannerCarousel), findsOneWidget);
  });

  testWidgets('supports custom arrowAlignment and arrow padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarousel(
            items: items,
            showArrows: true,
            arrowAlignment: Alignment.topCenter,
            arrowPadding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('supports arrowsOnSlide positioning', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarousel(
            items: items,
            showArrows: true,
            arrowsOnSlide: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
