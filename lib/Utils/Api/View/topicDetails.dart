import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // For rendering HTML
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:shimmer/shimmer.dart'; // For shimmer effect
import '../Controller/topicController.dart';
import '../Model/topicDetails.dart';

class HealthTopicPage extends StatefulWidget {
  final String topicId;
  final String topicTitle;

  HealthTopicPage({required this.topicId, required this.topicTitle});

  @override
  _HealthTopicPageState createState() => _HealthTopicPageState();
}

class _HealthTopicPageState extends State<HealthTopicPage> {
  late Future<HealthTopic> futureHealthTopic;

  @override
  void initState() {
    super.initState();
    futureHealthTopic = fetchTopicData(widget.topicId);
  }

  // Function to launch URLs
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  // Function to show an adaptive error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Shimmer Skeleton Widget
  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton for the image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Skeleton for the title
            Container(
              width: double.infinity,
              height: 24,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),

            // Skeleton for the description
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),

            // Skeleton for categories
            Wrap(
              spacing: 8,
              children: List.generate(
                3,
                (index) => Container(
                  width: 80,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Skeleton for sections
            const Text(
              'Sections:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              2,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Skeleton for section title
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),

                      // Skeleton for section description
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),

                      // Skeleton for section content
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicTitle),
        centerTitle: true,
        elevation: 4,
      ),
      body: FutureBuilder<HealthTopic>(
        future: futureHealthTopic,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerSkeleton(); // Show shimmer skeleton while loading
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog(context, 'Error: ${snapshot.error}');
            });
            return const Center(child: Text(''));
          } else if (!snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog(context, 'No data found.');
            });
            return const Center(child: Text(''));
          } else {
            HealthTopic healthTopic = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actual content goes here (same as before)
                  if (healthTopic.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        healthTopic.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/medLogo.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),

                  Html(
                    data: healthTopic.title,
                    style: {
                      "body": Style(
                        fontSize: FontSize(24.0),
                        fontWeight: FontWeight.bold,
                        margin: Margins.zero,
                      ),
                    },
                  ),

                  Html(
                    data: healthTopic.myHFDescription,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.0),
                        lineHeight: const LineHeight(1.5),
                      ),
                    },
                  ),
                  const Text(
                    'Categories:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 2,
                    children: healthTopic.categories
                        .split(',')
                        .map(
                          (category) => Chip(
                            backgroundColor: const Color(0xFF1565C0),
                            labelStyle: const TextStyle(color: Colors.white),
                            labelPadding: const EdgeInsets.all(5),
                            label: Text(category.trim()),
                          ),
                        )
                        .toList(),
                  ),

                  const Text(
                    'Sections:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...healthTopic.sections.section.take(2).map((section) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(
                              data: section.title,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(18.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              },
                            ),
                            Html(
                              data: section.description,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16.0),
                                ),
                              },
                            ),
                            Html(
                              data: section.content,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16.0),
                                ),
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchUrl(healthTopic.accessibleVersion);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("See More Details Here"),
                    ),
                  ),

                  const Text(
                    'Related Items:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...healthTopic.relatedItems.relatedItem.map((item) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          _launchUrl(item.url);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: item.title,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(18.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchUrl(healthTopic.healthfinderUrl);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Explore Our Health Tool"),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
