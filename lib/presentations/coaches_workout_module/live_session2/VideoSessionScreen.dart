import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../provider/coach_services_provider.dart';

class VideoSessionScreen extends StatefulWidget {
  final String url;

  const VideoSessionScreen({
    super.key,
    required this.url,
  });

  @override
  State<VideoSessionScreen> createState() => _VideoSessionScreenState();
}

class _VideoSessionScreenState extends State<VideoSessionScreen> {
  VideoPlayerController? _controller;

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  bool _showControls = true;

  String get _cleanUrl => widget.url.trim();

  bool get _isValidVideoUrl {
    final String url = _cleanUrl.toLowerCase();

    if (url.isEmpty) return false;

    if (url.contains('no_image')) return false;

    if (url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.webp') ||
        url.endsWith('.gif')) {
      return false;
    }

    final Uri? uri = Uri.tryParse(_cleanUrl);

    if (uri == null) return false;

    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    debugPrint('========== VIDEO SESSION ==========');
    debugPrint('Video URL => $_cleanUrl');

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    if (!_isValidVideoUrl) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Invalid video url';
      });

      return;
    }

    try {
      await _controller?.dispose();

      final VideoPlayerController controller =
      VideoPlayerController.networkUrl(
        Uri.parse(_cleanUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );

      _controller = controller;

      controller.addListener(_videoListener);

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = false;
      });

      await controller.play();

      _hideControlsLater();
    } catch (error, stack) {
      debugPrint('Video initialize error: $error');
      debugPrint(stack.toString());

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  void _videoListener() {
    final VideoPlayerController? controller = _controller;

    if (controller == null) return;

    if (controller.value.hasError) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage =
            controller.value.errorDescription ?? 'Cannot play video';
      });

      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _hideControlsLater() {
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final VideoPlayerController? controller = _controller;

      if (controller == null || !controller.value.isInitialized) return;

      if (controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final VideoPlayerController? controller = _controller;

    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();

      if (!mounted) return;

      setState(() {
        _showControls = true;
      });
    } else {
      await controller.play();

      if (!mounted) return;

      setState(() {
        _showControls = true;
      });

      _hideControlsLater();
    }
  }

  Future<void> _seekBy(Duration offset) async {
    final VideoPlayerController? controller = _controller;

    if (controller == null || !controller.value.isInitialized) return;

    final Duration currentPosition = controller.value.position;
    final Duration duration = controller.value.duration;

    Duration newPosition = currentPosition + offset;

    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    }

    if (newPosition > duration) {
      newPosition = duration;
    }

    await controller.seekTo(newPosition);
  }

  Future<void> _onSliderChanged(double value) async {
    final VideoPlayerController? controller = _controller;

    if (controller == null || !controller.value.isInitialized) return;

    final Duration duration = controller.value.duration;

    final int newMilliseconds =
    (duration.inMilliseconds * value).round();

    await controller.seekTo(
      Duration(milliseconds: newMilliseconds),
    );
  }

  String _formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _hideControlsLater();
    }
  }

  void _openCommentSheet() {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Add comment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final String comment =
                    commentController.text.trim();

                    if (comment.isEmpty) return;

                    debugPrint('Comment: $comment');

                    Navigator.pop(context);

                    // TODO: call provider/API here.
                  },
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      commentController.dispose();
    });
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }

  Widget _errorView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Cannot load video',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initVideo,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _videoView(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio == 0
                  ? 16 / 9
                  : controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          if (_showControls) _controlsOverlay(controller),
        ],
      ),
    );
  }

  Widget _controlsOverlay(VideoPlayerController controller) {
    final Duration position = controller.value.position;
    final Duration duration = controller.value.duration;

    final double progress = duration.inMilliseconds == 0
        ? 0
        : position.inMilliseconds / duration.inMilliseconds;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _seekBy(const Duration(seconds: -10));
                      },
                      iconSize: 40,
                      color: Colors.white,
                      icon: const Icon(Icons.replay_10),
                    ),
                    const SizedBox(width: 18),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: mainColor,
                      child: IconButton(
                        onPressed: _togglePlay,
                        color: Colors.white,
                        iconSize: 34,
                        icon: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    IconButton(
                      onPressed: () {
                        _seekBy(const Duration(seconds: 10));
                      },
                      iconSize: 40,
                      color: Colors.white,
                      icon: const Icon(Icons.forward_10),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: progress.clamp(0, 1),
                      activeColor: mainColor,
                      inactiveColor: Colors.white38,
                      onChanged: _onSliderChanged,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    final VideoPlayerController? controller = _controller;

    if (_isLoading) {
      return _loadingView();
    }

    if (_hasError) {
      return _errorView();
    }

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text(
          'Cannot load video',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return _videoView(controller);
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<CoachServicesProvider>(
          builder: (context, provider, _) {
            return Text(
              provider.courseDetailsResponse == null
                  ? ''
                  : provider.courseDetailsResponse!.data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Add comment',
            icon: Icon(
              Icons.add_comment_outlined,
              color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
            ),
            onPressed: _openCommentSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: _body(),
        ),
      ),
      floatingActionButton:
      controller != null && controller.value.isInitialized && !_hasError
          ? FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: _togglePlay,
        child: Icon(
          controller.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
          color: Colors.white,
        ),
      )
          : null,
    );
  }
}