import 'package:flutter/material.dart';
import 'salt_water_fish_detail_page.dart'; // Ensure this page has the updated styling too

class SaltWaterFishPage extends StatelessWidget {
  const SaltWaterFishPage({super.key});

  // Data remains the same
  final List<Map<String, dynamic>> fishList = const [
    {
      "name": "Clownfish",
      "scientific": "Amphiprioninae",
      "image": "assets/images/library/salt_fish/clown-fish.webp",
      "desc": "Small, peaceful fish known for bonding with sea anemones.",
      "details": {
        "temp": "24°C - 27°C",
        "ph": "8.1 - 8.4",
        "tank": "75+ liters",
        "care": "Easy",
        "food": "Pellets, Flakes, Frozen food",
        "behavior": "Peaceful, pairs recommended",
        "about":
        "Clownfish are iconic saltwater species known for their bright orange colors and symbiotic relationship with sea anemones. They are hardy and great for beginners in marine aquariums."
      }
    },
    {
      "name": "Blue Tang",
      "scientific": "Paracanthurus hepatus",
      "image": "assets/images/library/salt_fish/blue_tang.jpeg",
      "desc": "Fast swimmers that require large tanks.",
      "details": {
        "temp": "24°C - 27°C",
        "ph": "8.1 - 8.4",
        "tank": "300+ liters",
        "care": "Hard",
        "food": "Algae, Seaweed, Pellets",
        "behavior": "Active swimmer",
        "about":
        "Blue Tangs are active and require a spacious tank. They are sensitive to water changes and need strong filtration. Made famous by the movie 'Finding Dory'."
      }
    },
    {
      "name": "Yellow Tang",
      "scientific": "Zebrasoma flavescens",
      "image": "assets/images/library/salt_fish/yellow_tang.jpeg",
      "desc": "Bright yellow, hardy, and peaceful marine fish.",
      "details": {
        "temp": "24°C - 28°C",
        "ph": "8.0 - 8.4",
        "tank": "200+ liters",
        "care": "Medium",
        "food": "Algae, Greens, Seaweed",
        "behavior": "Semi-aggressive",
        "about":
        "Yellow Tangs are popular saltwater fish known for their striking yellow color. They need plenty of algae to graze on and a tank with good swimming space."
      }
    },
    {
      "name": "Mandarin Dragonet",
      "scientific": "Synchiropus splendidus",
      "image": "assets/images/library/salt_fish/mandarin_dragonet.jpg",
      "desc": "Extremely colorful but requires live food.",
      "details": {
        "temp": "24°C - 27°C",
        "ph": "8.1 - 8.4",
        "tank": "100+ liters (mature tank)",
        "care": "Hard",
        "food": "Live copepods",
        "behavior": "Peaceful",
        "about":
        "Mandarin Dragonets are one of the most beautiful marine fish but are difficult to care for. They need an established tank full of copepods to survive."
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Define the color scheme for salt water to be distinct from fresh water (Teal)
    const Color primaryColor = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Salt Water Fish Library 🌊"), // Added emoji
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: fishList.length,
        itemBuilder: (context, index) {
          final fish = fishList[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Ensure this target page uses the correct image path (without the double 'assets/')
                  builder: (_) => SaltWaterFishDetailPage(
                    name: fish["name"],
                    scientific: fish["scientific"],
                    image: fish["image"],
                    details: fish["details"],
                  ),
                ),
              );
            },
            // 🌟 Applying the enhanced Card design
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // 🖼️ Image Section
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    child: Image.asset(
                      fish["image"],
                      width: 130, // Consistent size
                      height: 130,
                      fit: BoxFit.cover,
                      // Placeholder/error handling added for robustness
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 130,
                          height: 130,
                          child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                        );
                      },
                    ),
                  ),

                  // 📝 Text Details Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fish["name"],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor // Highlight fish name with the Salt Water theme color
                            ),
                          ),
                          Text(
                            fish["scientific"],
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey.shade700,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            fish["desc"],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),

                  // ▶️ Trailing Icon Section
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: primaryColor, // Use theme color for the icon
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
}