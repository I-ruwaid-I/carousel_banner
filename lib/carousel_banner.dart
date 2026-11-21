// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controller for programmatically controlling a [BannerCarousel].
///
/// Obtain via [BannerCarousel.controller] and use to navigate slides,
/// pause/resume autoplay, or jump to specific pages.
class CarouselController {
  _BannerCarouselState? _state;

  void _attach(_BannerCarouselState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Animates to the next slide.
  void next() {
    _state?._next();
  }

  /// Animates to the previous slide.
  void previous() {
    _state?._previous();
  }

  /// Animates to the slide at [page] (0-based index).
  ///
  /// The carousel will animate to the nearest virtual copy of that page
  /// to maintain the infinite loop illusion.
  void animateToPage(int page) {
    _state?._goTo(page);
  }

  /// Pauses autoplay if enabled.
  void pauseAutoplay() {
    _state?._pauseAutoplay();
  }

  /// Resumes autoplay if enabled and not paused by user interaction.
  void resumeAutoplay() {
    _state?._resumeAutoplay();
  }

  /// The current slide index (0-based), or null if not attached.
  int? get currentIndex => _state?._index;

  /// Whether autoplay is currently running.
  bool get isAutoplaying => _state?._isAutoplaying ?? false;

  /// Total number of slides, or null if not attached.
  int? get itemCount => _state?._count;
}

/// Background of a single carousel slide — either a solid [CarouselColorBackground]
/// or an [CarouselImageBackground]. Exactly one must be provided.
sealed class CarouselBackground {
  const CarouselBackground();
}

/// A solid or gradient color background for a carousel slide.
class CarouselColorBackground extends CarouselBackground {
  const CarouselColorBackground(this.color);

  /// The solid background color for the slide.
  final Color color;
}

/// An image background for a carousel slide.
class CarouselImageBackground extends CarouselBackground {
  const CarouselImageBackground(this.image);

  /// The image provider for the slide background.
  final ImageProvider image;
}

/// One slide in a [BannerCarousel].
///
/// [title] and [subtitle] are mandatory and are rendered at the bottom of the
/// slide. The slide background must be either a color or an image.
class CarouselItem {
  const CarouselItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.background,
    this.badgeText,
    this.badgeColor,
    this.ctaText,
    this.onCtaTap,
    this.heroTag,
  });

  final String id;
  final String title;
  final String subtitle;
  final CarouselBackground background;

  /// Optional Hero animation tag for seamless Netflix-style card-to-page transitions.
  /// Defaults to `'carousel_item_${id}'`.
  final String? heroTag;

  /// Optional badge text shown on top-left of the slide (e.g. "NEW", "50% OFF").
  final String? badgeText;

  /// Custom background color for the badge chip. If null, defaults to primary color.
  final Color? badgeColor;

  /// Optional Call To Action button label shown on the bottom right of the slide.
  final String? ctaText;

  /// Optional callback when the CTA button is tapped.
  final VoidCallback? onCtaTap;
}

/// A swipeable, infinitely looping carousel of banner slides.
///
/// Each slide has a colour or image background with a title/subtitle anchored
/// to the bottom over a subtle gradient scrim for readability. Supports
/// autoplay (with progress shown in the active dot), an optional [onTap]
/// callback, a custom [overlay], navigation arrows, keyboard navigation,
/// and dot indicators.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.items,
    this.height = 230,
    this.borderRadius = 24,
    this.autoplay = false,
    this.interval = const Duration(seconds: 4),
    this.showDots = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.overlay,
    this.onTap,
    this.onPageChanged,
    this.controller,
    this.showArrows = false,
    this.arrowBuilder,
    this.arrowPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.arrowSize = 40,
    this.arrowColor = Colors.white,
    this.arrowBackgroundColor = Colors.black26,
    this.arrowAlignment = Alignment.center,
    this.arrowsOnSlide = false,
    this.enableHero = true,
    this.viewportFraction = 1.0,
    this.enlargeCenterPage = false,
    this.aspectRatio,
  });

  final List<CarouselItem> items;
  final double height;
  final double borderRadius;
  final bool autoplay;
  final Duration interval;
  final bool showDots;
  final EdgeInsetsGeometry padding;

  /// Whether to wrap each slide card in a [Hero] widget for Netflix-style page transitions.
  /// Defaults to true.
  final bool enableHero;

  /// Alignment of the navigation arrows over the carousel.
  /// Defaults to [Alignment.center] (vertically centered on left/right edges).
  final AlignmentGeometry arrowAlignment;

  /// Whether navigation arrows should sit directly on top of the slide card
  /// (inset by slide [padding]) instead of outside on the outer carousel bounds.
  final bool arrowsOnSlide;

  /// The fraction of the viewport that each page should occupy.
  /// Defaults to 1.0. Values < 1.0 (e.g. 0.85) allow neighboring slides to show.
  final double viewportFraction;

  /// Whether to visually scale up the active center slide when [viewportFraction] < 1.0.
  final bool enlargeCenterPage;

  /// Optional aspect ratio of the banner (width / height).
  /// If provided, carousel height is determined dynamically based on container width.
  final double? aspectRatio;

  /// Optional decoration painted between the slide background and the text.
  ///
  /// Defaults to a bottom gradient scrim so the text stays readable. Pass a
  /// [BoxDecoration] to customise it, or `BoxDecoration()` for no overlay.
  final BoxDecoration? overlay;

  /// Optional callback fired when a slide is tapped.
  final ValueChanged<CarouselItem>? onTap;

  /// Called when the page changes (user swipe or autoplay).
  ///
  /// The parameter is the 0-based index of the new current slide.
  final ValueChanged<int>? onPageChanged;

  /// Optional controller for programmatic navigation and autoplay control.
  final CarouselController? controller;

  /// Whether to show navigation arrows on the sides.
  final bool showArrows;

  /// Custom builder for the navigation arrows.
  ///
  /// Receives (context, index, isLeft) where index is the current slide index
  /// and isLeft indicates whether this is the left (previous) arrow.
  /// If null, default arrows are used.
  final Widget Function(BuildContext context, int index, bool isLeft)?
  arrowBuilder;

  /// Horizontal padding around the arrows.
  final EdgeInsetsGeometry arrowPadding;

  /// Size of the default arrow icons.
  final double arrowSize;

  /// Color of the default arrow icons.
  final Color arrowColor;

  /// Background color of the default arrow circles.
  final Color arrowBackgroundColor;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel>
    with SingleTickerProviderStateMixin {
  /// Number of virtual copies used to fake an infinite loop.
  static const int _copies = 1000;

  late final PageController _controller;
  late final AnimationController _progress;
  int _page = 0;
  bool _paused = false;
  bool _userPaused = false;
  FocusNode? _focusNode;

  int get _count => widget.items.length;
  int get _index => _page % _count;
  bool get _isAutoplaying =>
      widget.autoplay && _count >= 2 && !_paused && !_userPaused;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _count * _copies,
      viewportFraction: widget.viewportFraction,
    );
    _progress = AnimationController(vsync: this, duration: widget.interval);
    _progress.addStatusListener((status) {
      if (status == AnimationStatus.completed) _next();
    });
    _focusNode = FocusNode();
    _focusNode!.addListener(_onFocusChange);
    widget.controller?._attach(this);
    _startAutoplay();
  }

  void _onFocusChange() {
    if (_focusNode!.hasFocus) {
      _userPaused = false;
      _startAutoplay();
    } else {
      _userPaused = true;
      _pauseAutoplay();
    }
  }

  @override
  void didUpdateWidget(covariant BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress.duration = widget.interval;
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _controller.dispose();
      _controller = PageController(
        initialPage: _page,
        viewportFraction: widget.viewportFraction,
      );
    } else if (oldWidget.items.length != _count) {
      _page = _count * _copies;
      if (_controller.hasClients) {
        _controller.jumpToPage(_page);
      }
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
    if (oldWidget.autoplay != widget.autoplay) {
      _startAutoplay();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    _focusNode?.dispose();
    widget.controller?._detach();
    super.dispose();
  }

  void _startAutoplay() {
    if (!mounted) return;
    if (!_isAutoplaying) {
      _progress.stop();
      return;
    }
    _progress.forward(from: 0);
  }

  void _pauseAutoplay() {
    _paused = true;
    _progress.stop();
  }

  void _resumeAutoplay() {
    _paused = false;
    _startAutoplay();
  }

  void _next() {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      _page + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _previous() {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      _page - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _goTo(int index) {
    if (index == _index) return;
    final target = _page - _page % _count + index;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
    _startAutoplay();
  }

  @override
  Widget build(BuildContext context) {
    final count = _count;
    if (count == 0) return const SizedBox.shrink();

    Widget carouselStack = Stack(
      children: [
        Listener(
          onPointerDown: (_) {
            if (!_userPaused) {
              _userPaused = true;
              _pauseAutoplay();
            }
          },
          onPointerUp: (_) {
            _userPaused = false;
            _startAutoplay();
          },
          onPointerCancel: (_) {
            _userPaused = false;
            _startAutoplay();
          },
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) {
              final newIndex = i % count;
              setState(() => _page = i);
              widget.onPageChanged?.call(newIndex);
              _startAutoplay();
            },
            itemBuilder: (context, i) {
              final item = widget.items[i % count];
              final slideWidget = Padding(
                padding: widget.padding,
                child: _BannerSlide(
                  item: item,
                  borderRadius: widget.borderRadius,
                  overlay: widget.overlay,
                  enableHero: widget.enableHero,
                  onTap:
                      widget.onTap == null ? null : () => widget.onTap!(item),
                ),
              );

              if (widget.enlargeCenterPage) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double scale = 1.0;
                    if (_controller.position.haveDimensions) {
                      final double page = _controller.page ?? _page.toDouble();
                      scale = (1 - (page - i).abs() * 0.15).clamp(0.85, 1.0);
                    } else {
                      scale = (i == _page) ? 1.0 : 0.85;
                    }
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: slideWidget,
                );
              }

              return slideWidget;
            },
          ),
        ),
        if (widget.showArrows && count > 1)
          Positioned.fill(
            child: Align(
              alignment: widget.arrowAlignment,
              child: _Arrows(
                index: _index,
                count: count,
                onPrevious: _previous,
                onNext: _next,
                arrowBuilder: widget.arrowBuilder,
                arrowPadding:
                    widget.arrowsOnSlide
                        ? widget.padding.add(widget.arrowPadding)
                        : widget.arrowPadding,
                arrowSize: widget.arrowSize,
                arrowColor: widget.arrowColor,
                arrowBackgroundColor: widget.arrowBackgroundColor,
              ),
            ),
          ),
      ],
    );

    Widget bannerContainer;
    if (widget.aspectRatio != null) {
      bannerContainer = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: carouselStack,
      );
    } else {
      bannerContainer = SizedBox(height: widget.height, child: carouselStack);
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _previous();
            _startAutoplay();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _next();
            _startAutoplay();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bannerContainer,
          if (widget.showDots && count > 1) ...[
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: _progress,
              builder:
                  (context, _) => _Dots(
                    count: count,
                    index: _index,
                    progress: widget.autoplay ? _progress.value : 1.0,
                    onTap: _goTo,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Arrows extends StatelessWidget {
  const _Arrows({
    required this.index,
    required this.count,
    required this.onPrevious,
    required this.onNext,
    this.arrowBuilder,
    this.arrowPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.arrowSize = 40,
    this.arrowColor = Colors.white,
    this.arrowBackgroundColor = Colors.black26,
  });

  final int index;
  final int count;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Widget Function(BuildContext context, int index, bool isLeft)?
  arrowBuilder;
  final EdgeInsetsGeometry arrowPadding;
  final double arrowSize;
  final Color arrowColor;
  final Color arrowBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: arrowPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ArrowButton(
            isLeft: true,
            onTap: onPrevious,
            size: arrowSize,
            color: arrowColor,
            backgroundColor: arrowBackgroundColor,
            builder: arrowBuilder,
            index: index,
          ),
          _ArrowButton(
            isLeft: false,
            onTap: onNext,
            size: arrowSize,
            color: arrowColor,
            backgroundColor: arrowBackgroundColor,
            builder: arrowBuilder,
            index: index,
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.isLeft,
    required this.onTap,
    required this.size,
    required this.color,
    required this.backgroundColor,
    this.builder,
    required this.index,
  });

  final bool isLeft;
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final Color backgroundColor;
  final Widget Function(BuildContext context, int index, bool isLeft)? builder;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return const SizedBox.shrink();

    if (builder != null) {
      return builder!(context, index, isLeft);
    }

    return Semantics(
      label: isLeft ? 'Previous slide' : 'Next slide',
      button: true,
      enabled: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isLeft ? Icons.chevron_left : Icons.chevron_right,
                color: color,
                size: size * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    required this.item,
    required this.borderRadius,
    this.overlay,
    this.onTap,
    this.enableHero = true,
  });

  final CarouselItem item;
  final double borderRadius;
  final BoxDecoration? overlay;
  final VoidCallback? onTap;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = item.badgeColor ?? theme.colorScheme.primary;

    final slide = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Background(background: item.background),
          // Overlay (defaults to a scrim) between background and text.
          DecoratedBox(
            decoration:
                overlay ??
                BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
          ),
          if (item.badgeText != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  item.badgeText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.15,
                            shadows: const [
                              Shadow(color: Colors.black45, blurRadius: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            shadows: const [
                              Shadow(color: Colors.black45, blurRadius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.ctaText != null) ...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        if (item.onCtaTap != null) {
                          item.onCtaTap!();
                        } else if (onTap != null) {
                          onTap!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          item.ctaText!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget result = slide;

    if (onTap != null) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: slide,
        ),
      );
    }

    if (enableHero) {
      final heroTag = item.heroTag ?? 'carousel_item_${item.id}';
      result = Hero(tag: heroTag, child: result);
    }

    return result;
  }
}

/// A ready-to-use Netflix-style expanded detail screen that opens seamlessly from a [CarouselItem] Hero transition.
class CarouselDetailPage extends StatelessWidget {
  const CarouselDetailPage({
    super.key,
    required this.item,
    this.heroTag,
    this.actionButtons,
    this.body,
  });

  final CarouselItem item;
  final String? heroTag;
  final List<Widget>? actionButtons;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final tag = heroTag ?? item.heroTag ?? 'carousel_item_${item.id}';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: tag,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _Background(background: item.background),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.badgeText != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      item.badgeColor ??
                                      theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.badgeText!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (actionButtons != null) ...[
                    Row(children: actionButtons!),
                    const SizedBox(height: 24),
                  ],
                  if (body != null) body!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.background});

  final CarouselBackground background;

  @override
  Widget build(BuildContext context) {
    return switch (background) {
      CarouselColorBackground(:final color) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, Color.lerp(color, Colors.black, 0.28)!],
          ),
        ),
      ),
      CarouselImageBackground(:final image) => Image(
        image: image,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    };
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.index,
    required this.progress,
    required this.onTap,
  });

  final int count;
  final int index;
  final double progress;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color:
                  i == index
                      ? scheme.primary.withValues(alpha: 0.22)
                      : scheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (i == index)
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(color: scheme.primary),
                  ),
                GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
