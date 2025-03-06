import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class AmazonCard extends StatefulWidget {
  @override
  _AmazonCardState createState() => _AmazonCardState();
}

class _AmazonCardState extends State<AmazonCard> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  final List<Map<String, String>> products = [
    {
      "name": "Pedigree",
      "image": "https://www.bigbasket.com/media/uploads/p/xxl/40242048_4-pedigree-dry-dog-food-complete-balanced-100-vegetarian-boosts-immunity-for-puppies-adults.jpg",
      "url": "https://amzn.in/d/feKJgmz"
    },
    {
      "name": "Dog Chew Toy",
      "image": "https://amanpetshop.com/cdn/shop/products/Meat-Up-Non-Toxic-Rubber-Dog-Chew-Bone-Toy_-Puppy-Dog-Teething-Toy-_Medium_---5-inches-Meat-Up-1667914580.jpg",
      "url": "https://amzn.in/d/0eZlIPc"
    },
    {
      "name": "Dog Collar",
      "image": "https://cdn11.bigcommerce.com/s-67hz0xd/images/stencil/1280x1280/products/447/1023/spiked_tough_dog_collar__33270.1648374272.jpg?c=2",
      "url": "https://amzn.in/d/d3PIbIw"
    },
    {
      "name": "Dog Bed",
      "image": "https://m.media-amazon.com/images/I/712rwlkatDL.jpg",
      "url": "https://amzn.in/d/9E6qiJm"
    },
    {
      "name": "Dog Shampoo",
      "image": "https://m.media-amazon.com/images/I/71R6qzbwB0L.jpg",
      "url": "https://amzn.in/d/9lvcSHf"
    },
    {
      "name": "Dog Feeder",
      "image": "https://m.media-amazon.com/images/I/71opisM5YpL.jpg",
      "url": "https://amzn.in/d/4AkwMIu"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        ""
    )..initialize().then((_) {
      _controller.setLooping(true);
      setState(() {});
    });

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Initialize slide animations for each card
    _slideAnimations = products.map((product) {
      return Tween<Offset>(
        begin: Offset(1.5, 0), // Slide from the right
        end: Offset.zero, // Slide to the center
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    setState(() {
      isLoading = true;
      _controller.play();
    });

    final Uri uri = Uri.parse(url);
    await Future.delayed(Duration(seconds: 3));

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }

    setState(() {
      isLoading = false;
      _controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Premium Shopping",
            style: GoogleFonts.fredoka(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.purple.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Product Grid with Slide Animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Adjust aspect ratio for better image fit
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: GestureDetector(
                    onTap: () => _launchURL(products[index]["url"]!),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image with Overlay
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Stack(
                                children: [
                                  Image.network(
                                    products[index]["image"]!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover, // Ensure the image covers the area
                                  ),
                                  // Gradient Overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  // Product Name Overlay
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text(
                                      products[index]["name"]!,
                                      style: GoogleFonts.fredoka(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Buy Now Button
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              onPressed: () => _launchURL(products[index]["url"]!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Green button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: Text(
                                "Buy Now",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading Screen with Video Background
          if (isLoading)
            Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: VideoPlayer(_controller),
                  ),
                  Positioned.fill(
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                          "Fetching premium deals...",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}