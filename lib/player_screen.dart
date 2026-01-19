import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data_handler.dart';

class PlayerScreen extends StatefulWidget {
  final Channel channel;
  final List<Channel> allChannels;

  PlayerScreen({required this.channel, required this.allChannels});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late Channel currentChannel;

  @override
  void initState() {
    super.initState();
    currentChannel = widget.channel;
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(currentChannel.url);
    await _videoPlayerController.initialize();
    
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              "Stream Error: Source might be offline",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    });
  }

  void _playChannel(Channel channel) {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    setState(() {
      currentChannel = channel;
      _chewieController = null;
    });
    initializePlayer();
  }

  void _launchTelegram() async {
    const url = 'https://t.me/your_channel_link'; // আপনার টেলিগ্রাম লিংক দিন
    if (await canLaunch(url)) {
      await launch(url);
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
    // রিলেটেড চ্যানেল ফিল্টার (সেম ক্যাটাগরি)
    List<Channel> relatedChannels = widget.allChannels
        .where((c) => c.category == currentChannel.category && c.name != currentChannel.name)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(currentChannel.name)),
      body: Column(
        children: [
          // 1. Video Player Area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : Center(child: CircularProgressIndicator()),
            ),
          ),

          // 2. Telegram Banner
          GestureDetector(
            onTap: _launchTelegram,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.blueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.telegram, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Join Our Telegram Channel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // 3. Related Channels Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("More in ${currentChannel.category}", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          // 4. Related Channels List
          Expanded(
            child: ListView.builder(
              itemCount: relatedChannels.length,
              itemBuilder: (context, index) {
                final relChannel = relatedChannels[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: relChannel.logo,
                      errorWidget: (_,__,___) => Icon(Icons.tv),
                    ),
                  ),
                  title: Text(relChannel.name),
                  onTap: () => _playChannel(relChannel),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
