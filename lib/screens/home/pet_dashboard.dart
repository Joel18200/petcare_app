import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class PetDashboard extends StatefulWidget {
  const PetDashboard({super.key});

  @override
  State<PetDashboard> createState() => _PetDashboardState();
}

class _PetDashboardState extends State<PetDashboard> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? longPressedIndex;
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _addPet() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController breedController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.pets, color: Colors.green[700]),
              const SizedBox(width: 10),
              Text("Add New Pet",
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green[700],
                  )),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField(
                  controller: nameController,
                  labelText: 'Pet Name',
                  prefixIcon: Icons.pets,
                  hint: 'e.g., Max, Bella',
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  controller: breedController,
                  labelText: 'Breed',
                  prefixIcon: Icons.category,
                  hint: 'e.g., Golden Retriever',
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  controller: ageController,
                  labelText: 'Age',
                  prefixIcon: Icons.cake,
                  hint: 'e.g., 2 years',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  controller: imageController,
                  labelText: 'Image URL',
                  prefixIcon: Icons.image,
                  hint: 'Paste image URL here',
                ),
                const SizedBox(height: 15),
                if (imageController.text.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageController.text,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        height: 100,
                        width: 100,
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.fredoka(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                String image = imageController.text.trim();
                String breed = breedController.text.trim();
                String age = ageController.text.trim();

                if (name.isNotEmpty && image.isNotEmpty) {
                  await _firestore.collection('pets').add({
                    'name': name,
                    'image': image,
                    'breed': breed,
                    'age': age,
                    'color': '#4CAF50',
                    'health': 80 + (DateTime.now().microsecond % 20),
                    'lastCheckup': DateTime.now().toString(),
                  });
                  Navigator.pop(context);
                  _showSnackBar('Pet added successfully!');
                } else {
                  _showSnackBar('Please fill all required fields');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text("Add Pet", style: GoogleFonts.fredoka(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
          labelStyle: GoogleFonts.fredoka(color: Colors.green[700]),
          hintStyle: GoogleFonts.fredoka(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          prefixIcon: Icon(prefixIcon, color: Colors.green),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onChanged: (value) {
          if (labelText == 'Image URL' && value.isNotEmpty) {
            setState(() {});
          }
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.fredoka()),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _deletePet(String docId, String petName) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Pet", style: GoogleFonts.fredoka(color: Colors.red)),
        content: Text(
          "Are you sure you want to remove $petName from your pets list?",
          style: GoogleFonts.fredoka(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: GoogleFonts.fredoka(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Delete", style: GoogleFonts.fredoka()),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await _firestore.collection('pets').doc(docId).delete();
      setState(() {
        longPressedIndex = null;
      });
      _showSnackBar('$petName has been removed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      extendBody: true,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return _buildEmptyState();
          }

          final pets = snapshot.data?.docs ?? [];

          return _buildDashboardContent(pets);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPet,
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.pets, color: Colors.white),
        elevation: 4,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
    ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.green[600],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hey Joel Samuel,",
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
              Text("Welcome back to Pawfect!",
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  )),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://png.pngtree.com/png-clipart/20240312/original/pngtree-man-profile-cartoon-doodle-kawaii-anime-coloring-page-cute-illustration-drawing-png-image_14568126.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_9iugpxgj.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            "Fetching your pets...",
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: Colors.green[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.fredoka(
              fontSize: 22,
              color: Colors.red[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            error,
            style: GoogleFonts.fredoka(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
            label: Text("Try Again", style: GoogleFonts.fredoka()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets1.lottiefiles.com/packages/lf20_syqnfe7c.json',
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 20),
          Text(
            'No Pets Found',
            style: GoogleFonts.fredoka(
                fontSize: 24, color: Colors.grey[700], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your first pet to start tracking their health and needs!',
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _addPet,
            icon: const Icon(Icons.pets),
            label: Text("Add Your First Pet", style: GoogleFonts.fredoka(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(List<QueryDocumentSnapshot> pets) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return Future.delayed(const Duration(milliseconds: 1500));
      },
      color: Colors.green,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMyPetsSection(pets),
            const SizedBox(height: 20),
            _buildPetLocationSection(),
            const SizedBox(height: 20),
            _buildPetHealthStatus(pets),
            const SizedBox(height: 20),
            _buildPetFoodSection(),
            const SizedBox(height: 20),
            _buildPetCareAdvice(),
            const SizedBox(height: 30), // For bottom space
          ],
        ),
      ),
    );
  }

  Widget _buildPetCareAdvice() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.lightbulb, "Pet Care Tips", Colors.amber),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              final tips = [
                {
                  "title": "Exercise Needs",
                  "content":
                  "Make sure your dog gets at least 30 minutes of exercise daily to maintain good health and prevent behavioral issues.",
                  "icon": Icons.directions_run,
                },
                {
                  "title": "Healthy Diet",
                  "content":
                  "Feed your pet a balanced diet appropriate for their age, size, and activity level. Consult your vet for specific recommendations.",
                  "icon": Icons.restaurant_menu,
                },
                {
                  "title": "Regular Grooming",
                  "content":
                  "Regular brushing removes loose fur and distributes skin oils. It also helps you spot any skin issues early.",
                  "icon": Icons.brush,
                },
              ];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(tips[index]["icon"] as IconData, color: Colors.amber[800]),
                  ),
                  title: Text(
                    tips[index]["title"] as String,
                    style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                  childrenPadding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  children: [
                    Text(
                      tips[index]["content"] as String,
                      style: GoogleFonts.fredoka(color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.help_outline),
              label: Text("View All Pet Care Resources", style: GoogleFonts.fredoka()),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber[800],
                side: BorderSide(color: Colors.amber[800]!),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPetsSection(List<QueryDocumentSnapshot> pets) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.pets, "My Pets", Colors.green),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              height: 130,
              child: pets.isEmpty
                  ? Center(
                child: Text(
                  "No pets added yet. Tap 'Add' to get started!",
                  style: GoogleFonts.fredoka(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  final petData = pet.data() as Map<String, dynamic>;
                  final name = petData['name'] ?? 'Unnamed';
                  final image = petData['image'] ?? '';
                  final breed = petData['breed'] ?? 'Unknown';

                  return _buildPetItem(
                    pet.id,
                    name,
                    image,
                    breed,
                    index,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addPet,
                  icon: const Icon(Icons.add_circle),
                  label: Text("Add Pet", style: GoogleFonts.fredoka()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[700],
                    side: BorderSide(color: Colors.green[700]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  label: Text("Manage Pets", style: GoogleFonts.fredoka()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetItem(String id, String name, String image, String breed, int index) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            longPressedIndex = index;
          });
          HapticFeedback.mediumImpact();
        },
        onTap: () {
          // Navigate to pet detail page
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green[300]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'pet-$id',
                      child: CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 35,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          breed,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fredoka(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (longPressedIndex == index)
              Positioned(
                top: -10,
                right: -10,
                child: GestureDetector(
                  onTap: () => _deletePet(id, name),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                    padding: const EdgeInsets.all(5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetLocationSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.location_on, "Pet Location", Colors.orange),
          const SizedBox(height: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: 'https://t4.ftcdn.net/jpg/01/24/27/05/360_F_124270591_CtuUNrS8u5uvyH9BFCLgSi4ayLeIzZj2.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Live Tracking",
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pets, size: 14, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        "Safe Zone",
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Your pets are in the designated safe zone, 50m from home",
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.my_location),
                  label: Text("Track Now", style: GoogleFonts.fredoka()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map),
                  label: Text("Set Safe Zone", style: GoogleFonts.fredoka()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange[700],
                    side: BorderSide(color: Colors.orange[700]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetHealthStatus(List<QueryDocumentSnapshot> pets) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.monitor_heart_outlined, "Pet Health Status", Colors.purple),
          const SizedBox(height: 12),
          pets.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.pets, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    "Add pets to monitor their health status",
                    style: GoogleFonts.fredoka(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              : SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final petData = pets[index].data() as Map<String, dynamic>;
                final health = petData['health'] ?? 80;

                return _healthStatusCard(
                  petData['name'] ?? 'Unnamed',
                  health,
                  petData['color'] ?? '#4CAF50',
                  petData['image'] ?? '',
                  petData['lastCheckup'] ?? DateTime.now().toString(),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.health_and_safety),
                  label: Text("Health Report", style: GoogleFonts.fredoka()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.medical_services),
                  label: Text("Vet Services", style: GoogleFonts.fredoka()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                    side: BorderSide(color: Colors.purple[700]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetFoodSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.restaurant_menu, "Pet Food & Supplies", Colors.blue),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                _foodItem(
                  "Josera",
                  "Josi Dog Master Mix",
                  "900g",
                  "https://m.media-amazon.com/images/I/61lO+2hTFpL.jpg",
                  "https://amzn.in/d/eY6B2DN",
                  4.3,
                ),
                _foodItem(
                  "Happy Pet",
                  "Happy Dog - Profi Line High Energy",
                  "500g",
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPIfLw_hPVqvGWT8jbE2T2SsTDAqECKyVtp0lynlGuQiELup5LWQm2lu4W0rLzcVbSWdw&usqp=CAU",
                  "https://royalpetstoreonline.com.mt/product/happy-dog-profi-line-sportive-20kg/",
                  4.0,
                ),
                _foodItem(
                  "Pedigree",
                  "Pedigree Puppy Dry Dog Food",
                  "3kg",
                  "https://www.pedigree.in/files/styles/webp/public/2024-03/MicrosoftTeams-image%20%286%29.png.webp?VersionId=t5BQaJnooda_Z_Mlev10xZ8sBDYlVUyv&itok=m2iTpBnV",
                  "https://amzn.in/d/feKJgmz",
                  4.5,
                ),
                _foodItem(
                  "Dog Feeder",
                  "Automatic Pet Feeder",
                  "3.8L",
                  "https://m.media-amazon.com/images/I/71opisM5YpL.jpg",
                  "https://amzn.in/d/4AkwMIu",
                  4.2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                  label: Text("Shop Now", style: GoogleFonts.fredoka()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _foodItem(String brand, String name, String weight, String imageUrl, String url, double rating) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[50]!),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.grey[300]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$brand - $weight",
                      style: GoogleFonts.fredoka(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < rating.floor() ? Icons.star : (index < rating ? Icons.star_half : Icons.star_border),
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.fredoka(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Free Delivery",
                            style: GoogleFonts.fredoka(
                              fontSize: 8,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Top Rated",
                            style: GoogleFonts.fredoka(
                              fontSize: 8,
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "See All",
                    style: GoogleFonts.fredoka(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios, color: color, size: 12),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 20),
      ],
    );
  }

  Widget _healthStatusCard(String name, int value, String colorHex, String imageUrl, String lastCheckup) {
    Color barColor = value > 70 ? Colors.green[600]! : Colors.orange[600]!;
    final checkupDate = DateTime.tryParse(lastCheckup) ?? DateTime.now();
    final daysSinceCheckup = DateTime.now().difference(checkupDate).inDays;

    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[50]!,
            Colors.purple[100]!.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.purple[300]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 45,
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 16,
                color: value > 70 ? Colors.green[600] : Colors.orange[600],
              ),
              const SizedBox(width: 5),
              Text(
                "Health: $value%",
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: value > 70 ? Colors.green[700] : Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value / 100,
                    minHeight: 8,
                    color: barColor,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                if (value > 40)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 40),
                    ),
                  ),
                if (value > 70)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 70),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Last checkup: $daysSinceCheckup days ago",
            style: GoogleFonts.fredoka(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add opacity if missing
    }
    return Color(int.parse(hex, radix: 16));
  }
}
