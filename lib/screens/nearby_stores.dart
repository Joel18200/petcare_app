import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import '../utils/map_utils.dart';

class NearbyStoresScreen extends StatefulWidget {
  const NearbyStoresScreen({super.key});

  @override
  State<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends State<NearbyStoresScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Add filter state variables
  String _selectedDistance = "All";
  String _selectedRating = "All";
  List<String> _selectedServices = [];

  // Original data lists
  final List<StoreModel> _allVetStores = [
    StoreModel(
      name: "RED VETS PET CLINIC",
      location: "ADOOR",
      rating: 4.7,
      distance: "2.5 km",
      distanceValue: 2.5,
      imageUrl: "https://static.vecteezy.com/system/resources/previews/047/784/272/non_2x/a-cartoon-illustration-depicting-a-hospital-building-in-a-city-with-two-ambulances-parked-outside-the-sky-is-blue-with-white-clouds-free-vector.jpg",
      services: ["Emergency Care", "Vaccination", "Surgery"],
      openingHours: "8:00 AM - 8:00 PM",
      exactAddress: "RED VETS PET CLINIC ADOOR, ADOOR",
    ),
    StoreModel(
      name: "PAWSOME VET HOSPITAL",
      location: "KARUNAGAPPALLY",
      rating: 4.5,
      distance: "3.2 km",
      distanceValue: 3.2,
      imageUrl: "https://png.pngtree.com/png-clipart/20230923/original/pngtree-flat-paw-print-icon-for-pet-health-care-vector-png-image_12535766.png",
      services: ["Dental Care", "X-Ray", "Pet Pharmacy"],
      openingHours: "9:00 AM - 7:00 PM",
      exactAddress: "PAWSOME VET HOSPITAL KARUNAGAPPALLY, KARUNAGAPPALLY",
    ),
    StoreModel(
      name: "PET CARE CENTER",
      location: "KOLLAM",
      rating: 4.3,
      distance: "5.6 km",
      distanceValue: 5.6,
      imageUrl: "https://static.vecteezy.com/system/resources/previews/008/196/585/non_2x/pets-care-logo-template-this-logo-design-suitable-for-business-animal-pet-pet-care-dog-and-cat-veterinary-animal-centre-etc-vector.jpg",
      services: ["Vaccination", "Pet Pharmacy", "Boarding"],
      openingHours: "8:30 AM - 7:30 PM",
      exactAddress: "PET CARE CENTER KOLLAM, KOLLAM",
    ),
    StoreModel(
      name: "ANIMAL CARE HOSPITAL",
      location: "KOTTARAKKARA",
      rating: 4.9,
      distance: "8.1 km",
      distanceValue: 8.1,
      imageUrl: "https://www.shutterstock.com/image-vector/animal-care-icon-monochrome-simple-600nw-2261455309.jpg",
      services: ["Emergency Care", "Surgery", "Dental Care", "Boarding"],
      openingHours: "24 Hours",
      exactAddress: "ANIMAL CARE HOSPITAL KOTTARAKKARA, KOTTARAKKARA",
    ),
  ];

  final List<StoreModel> _allGroomingStores = [
    StoreModel(
      name: "Handz N Pawz",
      location: "KARUNAGAPPALLY",
      rating: 4.8,
      distance: "1.8 km",
      distanceValue: 1.8,
      imageUrl: "https://media.istockphoto.com/id/1405431897/vector/shaggy-dog.jpg?s=612x612&w=0&k=20&c=pyrubEzEkbly7lay_L6L05ACim5G-TXajgy2Wxgpy5A=",
      services: ["Full Grooming", "Nail Trimming", "Fur Styling"],
      openingHours: "10:00 AM - 6:00 PM",
      exactAddress: "Handz N Pawz Karunagappally, Karunagappally",
    ),
    StoreModel(
      name: "Pampered Paws Salon",
      location: "ADOOR",
      rating: 4.6,
      distance: "2.7 km",
      distanceValue: 2.7,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVT-OkB4HjQJs5a45rgaX2TMB5iKXD5e-_dA&s",
      services: ["Bath & Blow Dry", "De-matting", "Ear Cleaning"],
      openingHours: "9:30 AM - 6:30 PM",
      exactAddress: "Pampered Paws Salon ADOOR, ADOOR",
    ),
    StoreModel(
      name: "Fluffy Friends Grooming",
      location: "PUNALUR",
      rating: 4.2,
      distance: "6.3 km",
      distanceValue: 6.3,
      imageUrl: "https://s3-media0.fl.yelpcdn.com/bphoto/rfX5srI_i8qn48lm07bqcw/348s.jpg",
      services: ["Full Grooming", "Nail Trimming", "Teeth Cleaning"],
      openingHours: "9:00 AM - 5:00 PM",
      exactAddress: "Fluffy Friends Grooming PUNALUR, PUNALUR",
    ),
    StoreModel(
      name: "The Grooming Lounge",
      location: "KOLLAM",
      rating: 4.9,
      distance: "9.5 km",
      distanceValue: 9.5,
      imageUrl: "https://c8.alamy.com/comp/2F6RR3F/business-card-for-the-grooming-salon-illustration-of-a-groomer-taking-care-of-the-dog-blow-drying-and-styling-vector-in-flat-style-2F6RR3F.jpg",
      services: ["Full Service Grooming", "Spa Treatments", "Breed-Specific Styling"],
      openingHours: "10:00 AM - 7:00 PM",
      exactAddress: "The Grooming Lounge KOLLAM, KOLLAM",
    ),
  ];

  // Filtered lists
  List<StoreModel> _vetStores = [];
  List<StoreModel> _groomingStores = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize filtered lists with all stores
    _vetStores = List.from(_allVetStores);
    _groomingStores = List.from(_allGroomingStores);

    // Add search listener
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Search functionality
  void _performSearch() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty && _selectedDistance == "All" && _selectedRating == "All" && _selectedServices.isEmpty) {
        // No filters, show all
        _vetStores = List.from(_allVetStores);
        _groomingStores = List.from(_allGroomingStores);
      } else {
        // Filter vet stores
        _vetStores = _allVetStores.where((store) {
          bool matchesSearch = query.isEmpty ||
              store.name.toLowerCase().contains(query) ||
              store.location.toLowerCase().contains(query) ||
              store.services.any((service) => service.toLowerCase().contains(query));

          bool matchesDistance = _matchesDistance(store);
          bool matchesRating = _matchesRating(store);
          bool matchesServices = _matchesServices(store);

          return matchesSearch && matchesDistance && matchesRating && matchesServices;
        }).toList();

        // Filter grooming stores
        _groomingStores = _allGroomingStores.where((store) {
          bool matchesSearch = query.isEmpty ||
              store.name.toLowerCase().contains(query) ||
              store.location.toLowerCase().contains(query) ||
              store.services.any((service) => service.toLowerCase().contains(query));

          bool matchesDistance = _matchesDistance(store);
          bool matchesRating = _matchesRating(store);
          bool matchesServices = _matchesServices(store);

          return matchesSearch && matchesDistance && matchesRating && matchesServices;
        }).toList();
      }
    });
  }

  // Helper methods for filtering
  bool _matchesDistance(StoreModel store) {
    if (_selectedDistance == "All") return true;
    if (_selectedDistance == "Nearest") return store.distanceValue <= 3;
    if (_selectedDistance == "Within 5km") return store.distanceValue <= 5;
    if (_selectedDistance == "Within 10km") return store.distanceValue <= 10;
    return true;
  }

  bool _matchesRating(StoreModel store) {
    if (_selectedRating == "All") return true;
    if (_selectedRating == "4★ & above") return store.rating >= 4.0;
    if (_selectedRating == "3★ & above") return store.rating >= 3.0;
    return true;
  }

  bool _matchesServices(StoreModel store) {
    if (_selectedServices.isEmpty) return true;
    return _selectedServices.any((service) =>
        store.services.any((storeService) =>
            storeService.toLowerCase().contains(service.toLowerCase())));
  }

  // Apply filters
  void _applyFilters() {
    _performSearch();
  }

  // Reset filters
  void _resetFilters() {
    setState(() {
      _selectedDistance = "All";
      _selectedRating = "All";
      _selectedServices = [];
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            SliverToBoxAdapter(
              child: _buildTabBar(),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVetList(),
            _buildGroomingList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNearbyOptionsModal(context);
        },
        backgroundColor: greenColor,
        icon: const Icon(Icons.location_on),
        label: Text("Nearby", style: GoogleFonts.fredoka()),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: greenColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Pet Care Services",
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    greenColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            _showFilterDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search vets, groomers, or services...",
          hintStyle: GoogleFonts.fredoka(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: greenColor),
          suffixIcon: _isSearching
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: greenColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(
            icon: Icon(Icons.medical_services),
            text: "Veterinarians",
          ),
          Tab(
            icon: Icon(Icons.content_cut),
            text: "Grooming",
          ),
        ],
      ),
    );
  }

  Widget _buildVetList() {
    if (_vetStores.isEmpty && _isSearching) {
      return _buildNoResultsFound();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _vetStores.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader("Top-Rated Veterinary Clinics");
          }
          final store = _vetStores[index - 1];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildStoreCard(store),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroomingList() {
    if (_groomingStores.isEmpty && _isSearching) {
      return _buildNoResultsFound();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groomingStores.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader("Professional Grooming Centers");
          }
          final store = _groomingStores[index - 1];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildStoreCard(store),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No Results Found",
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try different search terms or filters",
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _resetFilters();
            },
            icon: const Icon(Icons.refresh),
            label: Text("Reset Search", style: GoogleFonts.fredoka()),
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: greenColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (_isSearching || _selectedDistance != "All" || _selectedRating != "All" || _selectedServices.isNotEmpty)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    _resetFilters();
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(
                    "Clear All",
                    style: GoogleFonts.fredoka(fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: greenColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(StoreModel store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Hero(
                  tag: "store_${store.name}",
                  child: CachedNetworkImage(
                    imageUrl: store.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 180,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        store.rating.toString(),
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        store.distance,
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            store.location,
                            style: GoogleFonts.fredoka(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Hours: ${store.openingHours}",
                  style: GoogleFonts.fredoka(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: store.services
                      .map(
                        (service) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        service,
                        style: GoogleFonts.fredoka(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          MapUtils.openGoogleMaps(store.exactAddress);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Opening directions to ${store.name}",
                                style: GoogleFonts.fredoka(),
                              ),
                              backgroundColor: greenColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(10),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.directions),
                        label: Text(
                          "DIRECTIONS",
                          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () {
                          final Uri telUri = Uri(scheme: 'tel', path: '+91987654321');
                          launchUrl(telUri);
                        },
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // Temporary variables to store filter selections before applying
    String tempDistance = _selectedDistance;
    String tempRating = _selectedRating;
    List<String> tempServices = List.from(_selectedServices);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
              title: Text(
                "Filter Results",
                style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterOptionWithState(
                      "Distance",
                      ["All", "Nearest", "Within 5km", "Within 10km"],
                      tempDistance,
                          (value) => setState(() => tempDistance = value),
                    ),
                    _buildFilterOptionWithState(
                      "Rating",
                      ["All", "4★ & above", "3★ & above"],
                      tempRating,
                          (value) => setState(() => tempRating = value),
                    ),
                    _buildServicesFilterOption(
                      "Services",
                      ["Emergency", "Vaccination", "Grooming", "Boarding", "Dental", "Surgery", "Pet Pharmacy"],
                      tempServices,
                          (value) => setState(() {
                        if (tempServices.contains(value)) {
                          tempServices.remove(value);
                        } else {
                          tempServices.add(value);
                        }
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset temporary filter values
                    setState(() {
                      tempDistance = "All";
                      tempRating = "All";
                      tempServices = [];
                    });
                  },
                  child: Text("RESET", style: GoogleFonts.fredoka(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters and close dialog
                    Navigator.pop(context);

                    setState(() {
                      _selectedDistance = tempDistance;
                      _selectedRating = tempRating;
                      _selectedServices = tempServices;
                    });

                    _applyFilters();

                    // Show a feedback message
                    if (tempDistance != "All" || tempRating != "All" || tempServices.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Filters applied",
                            style: GoogleFonts.fredoka(),
                          ),
                          backgroundColor: greenColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(10),
                          action: SnackBarAction(
                            label: "CLEAR",
                            textColor: Colors.white,
                            onPressed: () {
                              _resetFilters();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                  ),
                  child: Text("APPLY", style: GoogleFonts.fredoka(color: Colors.white)),
                ),
              ],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptionWithState(
      String title,
      List<String> options,
      String selectedValue,
      Function(String) onSelected
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: selectedValue == option ? Colors.white : Colors.black87,
                ),
              ),
              selected: selectedValue == option,
              selectedColor: greenColor,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildServicesFilterOption(
      String title,
      List<String> options,
      List<String> selectedValues,
      Function(String) onToggle
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => FilterChip(
              label: Text(
                option,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: selectedValues.contains(option) ? Colors.white : Colors.black87,
                ),
              ),
              selected: selectedValues.contains(option),
              selectedColor: greenColor,
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                onToggle(option);
              },
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  void _showNearbyOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Find Nearby Pet Services",
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNearbyOption(
                    "🩺 Veterinary Clinics",
                    "Find emergency and regular veterinary care",
                    "https://www.google.com/maps/search/vets+near+me/",
                    Colors.blue[100]!,
                    Colors.blue,
                  ),
                  _buildNearbyOption(
                    "✂️ Pet Grooming",
                    "Professional grooming services for your pet",
                    "https://www.google.com/maps/search/pet+grooming+near+me/",
                    Colors.purple[100]!,
                    Colors.purple,
                  ),
                  _buildNearbyOption(
                    "🏪 Pet Stores",
                    "Shop for food, toys, and accessories",
                    "https://www.google.com/maps/search/pet+stores+near+me/",
                    Colors.amber[100]!,
                    Colors.amber[700]!,
                  ),
                  _buildNearbyOption(
                    "🏥 24/7 Emergency Vets",
                    "For urgent medical care any time",
                    "https://www.google.com/maps/search/emergency+vet+near+me/",
                    Colors.red[100]!,
                    Colors.red,
                  ),
                  _buildNearbyOption(
                    "🦮 Dog Parks",
                    "Places for your dog to play and socialize",
                    "https://www.google.com/maps/search/dog+parks+near+me/",
                    Colors.green[100]!,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyOption(
      String title,
      String subtitle,
      String url,
      Color backgroundColor,
      Color iconColor,
      ) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);

          // Show a confirmation message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Opening $title near you",
                style: GoogleFonts.fredoka(),
              ),
              backgroundColor: iconColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
            ),
          );
        } else {
          // Show error message if URL can't be launched
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Could not open maps. Please try again.",
                style: GoogleFonts.fredoka(),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: iconColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class StoreModel {
  final String name;
  final String location;
  final double rating;
  final String distance;
  final double distanceValue; // Added to make distance filtering easier
  final String imageUrl;
  final List<String> services;
  final String openingHours;
  final String exactAddress;

  StoreModel({
    required this.name,
    required this.location,
    required this.rating,
    required this.distance,
    required this.distanceValue,
    required this.imageUrl,
    required this.services,
    required this.openingHours,
    required this.exactAddress,
  });
}

// Make sure this is in your utils/map_utils.dart file
class MapUtils {
  static void openGoogleMaps(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$encodedAddress";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}