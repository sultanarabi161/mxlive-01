import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data_handler.dart';
import 'player_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> allChannels = [];
  List<Channel> filteredChannels = [];
  List<String> categories = ["All"];
  String selectedCategory = "All";
  String notice = "Loading notice...";
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    // নোটিশ লোড
    String fetchedNotice = await ApiService.fetchNotice();
    
    // চ্যানেল লোড
    try {
      var channels = await ApiService.fetchChannels();
      var cats = channels.map((e) => e.category).toSet().toList();
      cats.sort();
      
      setState(() {
        notice = fetchedNotice;
        allChannels = channels;
        filteredChannels = channels;
        categories = ["All", ...cats];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void filterChannels(String query) {
    List<Channel> temp = allChannels;
    
    // ক্যাটাগরি ফিল্টার
    if (selectedCategory != "All") {
      temp = temp.where((c) => c.category == selectedCategory).toList();
    }

    // সার্চ ফিল্টার
    if (query.isNotEmpty) {
      temp = temp.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    setState(() {
      filteredChannels = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    // স্মার্ট গ্রিড ক্যালকুলেশন: মোবাইল হলে ২, ট্যাব/পিসি হলে ৪
    int crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 40, errorBuilder: (_,__,___) => Text("mxlive")),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InfoScreen())),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Scrolling Notice Header
          Container(
            height: 30,
            color: Colors.blueGrey.shade900,
            child: Marquee(
              text: notice,
              style: TextStyle(color: Colors.white),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 50.0,
            ),
          ),

          // 2. Search & Category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Channels...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  onChanged: (val) => filterChannels(val),
                ),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategory = cat;
                              filterChannels(searchController.text);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. Channel Grid
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // ৪ বা ২ আইটেম
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredChannels.length,
                    itemBuilder: (context, index) {
                      final channel = filteredChannels[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(channel: channel, allChannels: allChannels),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: channel.logo,
                                    errorWidget: (context, url, error) => Icon(Icons.tv, size: 40),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  channel.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
