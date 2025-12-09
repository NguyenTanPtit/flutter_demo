import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/preview/preview_cubit.dart'; // Import your cubit

class PreviewScreen extends StatelessWidget {
  final String filePath;
  final bool isVideo;

  const PreviewScreen({super.key, required this.filePath, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PreviewCubit(),
      child: _PreviewView(filePath: filePath, isVideo: isVideo),
    );
  }
}

class _PreviewView extends StatefulWidget {
  final String filePath;
  final bool isVideo;

  const _PreviewView({required this.filePath, required this.isVideo});

  @override
  State<_PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<_PreviewView> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(File(widget.filePath))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setLooping(true);
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreviewCubit, PreviewState>(
      listener: (context, state) {
        if (state is PreviewSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved to Gallery!')));
          context.pop(); // Go back after saving
        } else if (state is PreviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Media Content
            Center(
              child: widget.isVideo
                  ? (_videoController != null && _videoController!.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
                  : const CircularProgressIndicator())
                  : Image.file(File(widget.filePath)),
            ),

            // Controls Overlay
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: BlocBuilder<PreviewCubit, PreviewState>(
                builder: (context, state) {
                  if (state is PreviewSaving) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Discard Button
                      FloatingActionButton(
                        heroTag: 'discard',
                        backgroundColor: Colors.red,
                        onPressed: () => context.pop(),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                      // Save Button
                      FloatingActionButton(
                        heroTag: 'save',
                        backgroundColor: Colors.green,
                        onPressed: () => context.read<PreviewCubit>().saveMedia(widget.filePath, widget.isVideo),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}