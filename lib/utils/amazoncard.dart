import 'package:flutter/material.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';
class AmazonCard extends StatefulWidget {
  @override
  _AmazonCardState createState() => _AmazonCardState();
}

class _AmazonCardState extends State<AmazonCard> with TickerProviderStateMixin {
  bool isLoading = false;
  bool _showDiscount = false;
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late List<Animation<Offset>> _slideAnimations;
  late PageController _featuredPageController;
  int _currentFeaturedIndex = 0;

  // Discount percentages for each product
  final List<int> discounts = [15, 25, 10, 30, 20, 35];

  final List<Map<String, String>> products = [
    {
      "name": "Pedigree Dog Food",
      "description": "Complete balanced nutrition for your furry friend",
      "image": "https://www.pedigree.in/files/styles/webp/public/2024-03/MicrosoftTeams-image%20%286%29.png.webp?VersionId=t5BQaJnooda_Z_Mlev10xZ8sBDYlVUyv&itok=m2iTpBnV",
      "url": "https://amzn.in/d/feKJgmz",
      "price": "₹695",
      "rating": "4.5"
    },
    {
      "name": "Durable Chew Toy",
      "description": "Non-toxic rubber teething toy for puppies",
      "image": "https://amanpetshop.com/cdn/shop/products/Meat-Up-Non-Toxic-Rubber-Dog-Chew-Bone-Toy_-Puppy-Dog-Teething-Toy-_Medium_---5-inches-Meat-Up-1667914580.jpg",
      "url": "https://amzn.in/d/4bcUjbA",
      "price": "₹299",
      "rating": "4.3"
    },
    {
      "name": "Premium Dog Collar",
      "description": "Stylish and comfortable collar for all breeds",
      "image": "https://cdn11.bigcommerce.com/s-67hz0xd/images/stencil/1280x1280/products/447/1023/spiked_tough_dog_collar__33270.1648374272.jpg?c=2",
      "url": "https://amzn.in/d/d3PIbIw",
      "price": "₹1,723",
      "rating": "4.7"
    },
    {
      "name": "Luxury Dog Bed",
      "description": "Orthopedic comfort for a good night's sleep",
      "image": "https://m.media-amazon.com/images/I/712rwlkatDL.jpg",
      "url": "https://amzn.in/d/9E6qiJm",
      "price": "₹28,902",
      "rating": "4.8"
    },
    {
      "name": "Organic Dog Shampoo",
      "description": "Gentle formula for sensitive skin",
      "image": "https://m.media-amazon.com/images/I/71R6qzbwB0L.jpg",
      "url": "https://amzn.in/d/9lvcSHf",
      "price": "₹765",
      "rating": "4.4"
    },
    {
      "name": "Automatic Dog Feeder",
      "description": "Smart feeding solution for busy pet parents",
      "image": "https://m.media-amazon.com/images/I/71opisM5YpL.jpg",
      "url": "https://amzn.in/d/4AkwMIu",
      "price": "₹8,793",
      "rating": "4.6"
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize featured products page controller
    _featuredPageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    // Initialize video controller
    _controller = VideoPlayerController.network(
        "https://assets.mixkit.co/videos/preview/mixkit-online-shopping-app-usage-of-a-smartphone-12592-large.mp4"
    )..initialize().then((_) {
      _controller.setLooping(true);
      setState(() {});
    });

    // Initialize animation controller for card entrance
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    // Initialize pulse animation for discount badges
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize slide animations for each card with staggered timing
    _slideAnimations = List.generate(products.length, (index) {
      final delay = index * 0.2;
      final curve = CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay.clamp(0.0, 0.9), // Ensure it doesn't exceed 1.0
          (delay + 0.6).clamp(0.0, 1.0), // Ensure it doesn't exceed 1.0
          curve: Curves.elasticOut,
        ),
      );

      return Tween<Offset>(
        begin: Offset(1.5, 0), // Slide from the right
        end: Offset.zero, // Slide to the center
      ).animate(curve);
    });

    // Start the animation
    _animationController.forward();

    // Show discount badges after a delay
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showDiscount = true;
        });
      }
    });

    // Auto-scroll featured products
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted && _featuredPageController.hasClients) {
        _currentFeaturedIndex = (_currentFeaturedIndex + 1) % 3;
        _featuredPageController.animateToPage(
          _currentFeaturedIndex,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    _featuredPageController.dispose();
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
      _showErrorSnackbar("Could not launch $url");
    }

    setState(() {
      isLoading = false;
      _controller.pause();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRatingStars(String rating) {
    double ratingValue = double.parse(rating);
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < ratingValue.floor()
                ? Icons.star
                : (index < ratingValue ? Icons.star_half : Icons.star_border),
            color: Colors.amber,
            size: 14,
          );
        }),
        SizedBox(width: 4),
        Text(
          rating,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts() {
    return Container(
      height: 180,
      child: PageView.builder(
        controller: _featuredPageController,
        itemCount: 3, // Show only top 3 products as featured
        onPageChanged: (index) {
          setState(() {
            _currentFeaturedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedPadding(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: _currentFeaturedIndex == index ? 0 : 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade800,
                    Colors.blue.shade800,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          backgroundBlendMode: BlendMode.overlay,
                          image: DecorationImage(
                            image: NetworkImage(products[index]["image"]!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flash deal badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.flash_on, color: Colors.white, size: 16),

                                    Text(
                                      "FLASH DEAL",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Product name
                              Text(
                                products[index]["name"]!,
                                style: GoogleFonts.fredoka(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              // Product description
                              Text(
                                products[index]["description"]!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),

                              Spacer(),

                              // Price and button row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price with discount
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index]["price"]!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        "₹${(int.parse(products[index]["price"]!.replaceAll("₹", "").replaceAll(",", "")) * (1 - discounts[index] / 100)).toStringAsFixed(0)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Shop now button
                                  ElevatedButton.icon(
                                    onPressed: () => _launchURL(products[index]["url"]!),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade800,
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                    ),
                                    icon: Icon(Icons.shopping_cart),
                                    label: Text(
                                      "Shop Now",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentFeaturedIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentFeaturedIndex == index
                ? Colors.blue.shade700
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.shopping_bag, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Premium Pet Shop",
              style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: greenColor,

            ),

      body: Stack(
        children: [
      // Main Background
      Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade50, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    ),

    // Search Bar
    Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
    height: 60,
    color: Colors.white,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 5,
    spreadRadius: 1,
    ),
    ],
    ),
    child: TextField(
    decoration: InputDecoration(
    hintText: "Search for pet products...",
    hintStyle: GoogleFonts.poppins(
    color: Colors.grey.shade600,
    fontSize: 14,
    ),
    prefixIcon: Icon(Icons.search, color: greenColor),
    suffixIcon: Icon(Icons.mic, color: greenColor),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical: 15),
    ),
    ),
    ),
    ),
    ),
    ),

    // Main Content
    Padding(
    padding: const EdgeInsets.only(top: 70.0,bottom:kBottomNavigationBarHeight),
    child: ListView(
      shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    padding: EdgeInsets.only(bottom: 20),
    children: [
    // Featured Products Slider
    Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 16.0),
    child: Row(
    children: [
    Icon(Icons.star, color: Colors.amber),
    Text(
    "Featured Products",
    style: GoogleFonts.fredoka(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
    ),
    ),
    ],
    ),
    ),
    SizedBox(
    height: 180,
    child: _buildFeaturedProducts(),
    ),
    SizedBox(height: 8),
    _buildPageIndicator(),
    // All Products Title
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
    children: [
    Icon(Icons.pets, color: Colors.brown),
    SizedBox(width: 8),
    Text(
    "All Pet Products",
    style: GoogleFonts.fredoka(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
    ),
    ),
    Spacer(),
    TextButton(
    onPressed: () {},
    child: Text(
    "View All",
    style: GoogleFonts.poppins(
    color: Colors.blue.shade700,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),
    ],
    ),
    ),

    // Products Grid with Animation
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: GridView.builder(
      itemCount:products.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 0.8,
    ),
    itemBuilder: (context, index) {
    // Calculate "original" price based on discount
    final price = products[index]["price"]!.replaceAll("₹", "").replaceAll(",", "");
    final originalPrice = (double.parse(price) / (1 - discounts[index] / 100)).toStringAsFixed(0);

    return SlideTransition(
    position: _slideAnimations[index],
    child: GestureDetector(
    onTap: () => _launchURL(products[index]["url"]!),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 15,
    offset: Offset(0, 5),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Image with Discount Badge
    Expanded(
    flex: 3,
    child: Stack(
    children: [
    // Product Image
    ClipRRect(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    child: Hero(
    tag: "product-$index",
    child: CachedNetworkImage(
    imageUrl: products[index]["image"]!,
    width: double.infinity,
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
    color: Colors.white,
    ),
    ),
    errorWidget: (context, url, error) => Container(
    color: Colors.grey[200],
    child: Icon(Icons.error, color: Colors.red),
    ),
    ),
    ),
    ),

    // Favorite Button
    Positioned(
    top: 10,
    right: 10,
    child: Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 5,
    spreadRadius: 1,
    ),
    ],
    ),
    child: Center(
    child: Icon(
    Icons.favorite_border,
    color: Colors.red,
    size: 20,
    ),
    ),
    ),
    ),

    // Discount Badge
    if (_showDiscount)
    Positioned(
    top: 10,
    left: 10,
    child: AnimatedBuilder(
    animation: _pulseAnimation,
    builder: (context, child) {
    return Transform.scale(
    scale: _pulseAnimation.value,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
    "${discounts[index]}% OFF",
    style: GoogleFonts.poppins(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    ),
    ),
    ),
    );
    },
    ),
    ),
    ],
    ),
    ),

    // Product Info
    Expanded(
    flex: 2,
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    // Product Name
    Text(
    products[index]["name"]!,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),

    // Rating
    _buildRatingStars(products[index]["rating"]!),

    // Price and Buy Button
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    // Price with discount
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "₹$originalPrice",
    style: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
    ),
    ),
    Text(
      products[index]["price"]!,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.blue.shade800,
      ),
    ),
    ],
    ),

      // Buy button
      Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _launchURL(products[index]["url"]!),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    ],
    ),
    ],
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

      // Newsletter Subscription
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.email_outlined, color: Colors.purple.shade700),
                  SizedBox(width: 10),
                  Text(
                    "Subscribe to Newsletter",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Get notified about exclusive deals and promotions for your pet.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.purple.shade800.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      "Subscribe",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Reviews Container
    ],
    ),
    ),

          // Loading Screen with Video Background
          if (isLoading)
            Positioned.fill(
              child: Stack(
                children: [
                  // Video background
                  Positioned.fill(
                    child: _controller.value.isInitialized
                        ? VideoPlayer(_controller)
                        : Container(color: Colors.black),
                  ),

                  // Overlay
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),

                  // Loading animation
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom loading animation
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                                  strokeWidth: 4,
                                ),
                              ),
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        // Loading text with typing animation
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: "Fetching the best deals for you...".length),
                          duration: Duration(seconds: 2),
                          builder: (context, value, child) {
                            return Text(
                              "Fetching the best deals for you...".substring(0, value),
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 10),
                        Text(
                          "You're being redirected to Amazon",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
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