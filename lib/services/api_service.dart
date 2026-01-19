import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel_model.dart';

class ApiService {
  // আপনার M3U লিঙ্ক
  static const String m3uUrl = "https://m3u.ch/pl/b3499faa747f2cd4597756dbb5ac2336_e78e8c1a1cebb153599e2d938ea41a50.m3u";
  
  // উদাহরণস্বরূপ একটি JSON নোটিশ লিঙ্ক (এটি আপনার নিজের হোস্টিং লিঙ্কে পরিবর্তন করবেন)
  static const String noticeUrl = "https://raw.githubusercontent.com/username/repo/main/notice.json";

  // চ্যানেল ফেচ করা
  static Future<List<Channel>> fetchChannels() async {
    try {
      final response = await http.get(Uri.parse(m3uUrl));
      if (response.statusCode == 200) {
        return _parseM3u(response.body);
      }
    } catch (e) {
      print("Error fetching channels: $e");
    }
    return [];
  }

  // M3U পার্সিং লজিক
  static List<Channel> _parseM3u(String body) {
    List<Channel> channels = [];
    final lines = LineSplitter.split(body).toList();

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('#EXTINF')) {
        // পরের লাইনটিই লিংক হবে
        if (i + 1 < lines.length && !lines[i+1].startsWith('#')) {
          channels.add(Channel.fromM3uLine(lines[i], lines[i + 1]));
        }
      }
    }
    return channels;
  }

  // নোটিশ ফেচ করা
  static Future<Notice?> fetchNotice() async {
    try {
      final response = await http.get(Uri.parse(noticeUrl));
      if (response.statusCode == 200) {
        return Notice.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error fetching notice: $e");
    }
    return null;
  }
}
