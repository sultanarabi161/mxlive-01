import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel_model.dart';

class PlayerScreen extends StatefulWidget {
  final Channel channel;
  final List<Channel> allChannels;

  const PlayerScreen({super.key, required this.channel, required this.allChannels});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.channel.url));
      await _videoPlayerController.initialize();
      
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9,
          errorBuilder: (context, errorMessage) {
            return const Center(child: Text("Stream Error: Source might be offline", style: TextStyle(color: Colors.white)));
          },
        );
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  void _launchTelegram() async {
    // আপনার টেলিগ্রাম লিংক এখানে দিন
    final Uri url = Uri.parse("https://t.me/your_channel");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // রিলেটেড চ্যানেল ফিল্টার (একই ক্যাটাগরির চ্যানেল)
    final relatedChannels = widget.allChannels
        .where((c) => c.category == widget.channel.category && c.url != widget.channel.url)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.channel.name)),
      body: Column(
        children: [
          // ১. প্লেয়ার এরিয়া
          Container(
            height: 250,
            color: Colors.black,
            child: isError
                ? const Center(child: Text("Error loading stream", style: TextStyle(color: Colors.red)))
                : _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : const Center(child: CircularProgressIndicator()),
          ),
          
          // ২. টেলিগ্রাম ব্যানার বাটন
          GestureDetector(
            onTap: _launchTelegram,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.blueAccent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Join Telegram Channel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Align(alignment: Alignment.centerLeft, child: Text("Related Channels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),

          // ৩. রিলেটেড চ্যানেল লিস্ট
          Expanded(
            child: ListView.builder(
              itemCount: relatedChannels.length,
              itemBuilder: (context, index) {
                final ch = relatedChannels[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: ch.logo,
                      errorWidget: (context, url, error) => const Icon(Icons.tv),
                    ),
                  ),
                  title: Text(ch.name),
                  subtitle: Text(ch.category),
                  onTap: () {
                    // প্লেয়ার রিলোড করার জন্য রিপ্লেস করা হচ্ছে
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(channel: ch, allChannels: widget.allChannels),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
