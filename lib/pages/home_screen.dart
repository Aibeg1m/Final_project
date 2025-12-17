import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "../models/news_article.dart";
import "../models/sport_section.dart";
import "../services/sport_news_services.dart";

class HomeScreen extends StatefulWidget {
  final List<SportSection> sports;
  final Set<String> selectedSports;

  const HomeScreen({
    super.key,
    required this.selectedSports,
    required this.sports,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final filteredSections = widget.sports
        .where((s) => widget.selectedSports.contains(s.title))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sports Trends",
          style: TextStyle(color: Color(0xFFE6EAF0)),
        ),
        backgroundColor: Color(0xFF163B63),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          ListView.builder(
            itemCount: filteredSections.length,
            itemBuilder: (context, index) {
              return TrendingSportSection(sport: filteredSections[index]);
            },
          ),
        ],
      ),
    );
  }
}

class TrendingSportSection extends StatelessWidget {
  final SportSection sport;

  const TrendingSportSection({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsArticle>>(
      future: SportsNewsService.fetch(sport.query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  sport.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                      color: Color(0xFFE6EAF0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];


                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () async {
                          await launchUrl(
                            Uri.parse(item.url),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: item.image.isEmpty
                                      ? Image.asset(
                                          "assets/no_image.png",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Image.network(
                                          item.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
                                                "assets/no_image.png",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
            ],
          ),
        );
      },
    );
  }
}
