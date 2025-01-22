import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:MedTime/Utils/Api/Controller/topicController.dart';
import 'package:MedTime/Utils/Api/View/topicDetails.dart';
import 'package:MedTime/Utils/Api/Model/topic.dart';
import 'package:shimmer/shimmer.dart';

class TopicsListPage extends StatefulWidget {
  const TopicsListPage({super.key});

  @override
  State<TopicsListPage> createState() => _TopicsListPageState();
}

class _TopicsListPageState extends State<TopicsListPage> {
  Future<List<Topic>>? _topics;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  void _loadTopics() {
    setState(() {
      _topics = fetchTopicsList(); // Fetch topics on initialization
    });
  }

  // Function to show adaptive error dialog
  void _showErrorDialog(String errorMessage) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _loadTopics(); // Retry fetching topics
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  // Shimmer effect for the list item
  Widget _buildShimmerItem() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
        ),
        title: Container(
          height: 20,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        trailing: Container(
          width: 16,
          height: 16,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Tips"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Topic>>(
        future: _topics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 10, // Number of shimmer items to show
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _buildShimmerItem();
                },
              ),
            );
          } else if (snapshot.hasError) {
            // Show adaptive error dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog('Failed to load topics. Please try again.');
            });
            return const Center(
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No topics available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final topics = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: topics.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: SvgPicture.network(
                          'https://odphp.health.gov/themes/custom/healthfinder/images/MyHF.svg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) => const Icon(
                            Icons.article,
                            size: 40,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // Navigate to the topic details page
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => HealthTopicPage(
                            topicTitle: topic.title,
                            topicId: topic.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
