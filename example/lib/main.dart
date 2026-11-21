// ignore_for_file: deprecated_member_use
import 'package:carousel_banner/carousel_banner.dart';
import 'package:flutter/material.dart' hide CarouselController;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Banner Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _tapped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carousel Banner')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Featured Banners (Viewport Fraction & Badges)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          BannerCarousel(
            autoplay: true,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            items: [
              CarouselItem(
                id: '1',
                title: 'Summer Sale',
                subtitle: 'Get up to 50% off on new arrivals.',
                badgeText: '50% OFF',
                badgeColor: Colors.deepOrange,
                ctaText: 'Shop Now',
                background: const CarouselColorBackground(Color(0xFF3B2F63)),
                onCtaTap: () => setState(() => _tapped = 'CTA: Shop Now'),
              ),
              CarouselItem(
                id: '2',
                title: 'New Collection',
                subtitle: 'Explore dark gradient themes.',
                badgeText: 'NEW',
                badgeColor: Colors.blueAccent,
                ctaText: 'Explore',
                background: const CarouselColorBackground(Color(0xFF1D3A5F)),
                onCtaTap: () => setState(() => _tapped = 'CTA: Explore'),
              ),
              CarouselItem(
                id: '3',
                title: 'Sunset Special',
                subtitle: 'Warm tones to end the day.',
                badgeText: 'LIMITED',
                ctaText: 'View',
                background: const CarouselColorBackground(Color(0xFF6B3A33)),
              ),
            ],
            onTap: (item) => setState(() => _tapped = item.title),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Responsive Aspect Ratio (16:9)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          BannerCarousel(
            aspectRatio: 16 / 9,
            items: const [
              CarouselItem(
                id: '4',
                title: 'Responsive Banner',
                subtitle: 'Automatically resizes using a 16:9 aspect ratio.',
                background: CarouselColorBackground(Color(0xFF2C5E3B)),
              ),
              CarouselItem(
                id: '5',
                title: 'Clean Design',
                subtitle: 'Bottom-anchored readability scrim.',
                background: CarouselColorBackground(Color(0xFF4A3E3D)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_tapped != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Last action: $_tapped',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
        ],
      ),
    );
  }
}
