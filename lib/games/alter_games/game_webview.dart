import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Enum for available games
enum HtmlGame {
  solarSystem,
  pendulum,
  gravity,
  waves,
  // Add more games here as needed
}

// Extension to get the game details
extension HtmlGameExtension on HtmlGame {
  String get fileName {
    switch (this) {
      case HtmlGame.solarSystem:
        return 'my-solar-system_en.html';
      case HtmlGame.pendulum:
        return 'pendulum_en.html';
      case HtmlGame.gravity:
        return 'gravity_en.html';
      case HtmlGame.waves:
        return 'waves_en.html';
    }
  }

  String get title {
    switch (this) {
      case HtmlGame.solarSystem:
        return 'Solar System Simulation';
      case HtmlGame.pendulum:
        return 'Pendulum Physics';
      case HtmlGame.gravity:
        return 'Gravity Simulation';
      case HtmlGame.waves:
        return 'Wave Physics';
    }
  }

  String get description {
    switch (this) {
      case HtmlGame.solarSystem:
        return 'Explore planetary motion and orbital mechanics';
      case HtmlGame.pendulum:
        return 'Study simple harmonic motion with pendulums';
      case HtmlGame.gravity:
        return 'Learn about gravitational forces and fields';
      case HtmlGame.waves:
        return 'Investigate wave properties and behaviors';
    }
  }
}

class LocalHtmlGame extends StatefulWidget {
  final HtmlGame game;
  final bool showAppBar;
  final Widget Function(BuildContext)? loadingBuilder;
  final Function(WebViewController)? onWebViewCreated;

  const LocalHtmlGame({
    Key? key,
    required this.game,
    this.showAppBar = true,
    this.loadingBuilder,
    this.onWebViewCreated,
  }) : super(key: key);

  @override
  _LocalHtmlGameState createState() => _LocalHtmlGameState();
}

class _LocalHtmlGameState extends State<LocalHtmlGame> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1a1a1a)) // Dark background instead of white
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );
    _loadGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set system navigation bar color to match scaffold background
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _loadGame() async {
    final assetPath = 'assets/html/${widget.game.fileName}';
    await _controller.loadFlutterAsset(assetPath);
    widget.onWebViewCreated?.call(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final loader = widget.loadingBuilder?.call(context) ??
        Center(
          child: SizedBox(
            width: double.infinity,
            child: BouncingDotsLoading(
              color: context.whiteColor,
              message: '${widget.game.title}',
              size: context.heightPercent(10),
              dotSize: context.iconSize(6, xs: 3, sm: 4, md: 5, lg: 7, xl: 8),
            ),
          ),
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: context.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: context.primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              // Full Screen WebView
              Positioned.fill(
                child: WebViewWidget(controller: _controller),
              ),
              // Loading Indicator
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: context.primaryColor,
                    child: loader,
                  ),
                ),
              // Floating Back Button
              if (widget.showAppBar)
                Positioned(
                  top: 16,
                  left: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}