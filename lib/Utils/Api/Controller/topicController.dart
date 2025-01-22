import '../Dio/DioHelper.dart';
import '../Model/topic.dart';
import '../Model/topicDetails.dart';

Future<List<Topic>> fetchTopicsList() async {
  try {
    var response = await DioHelper().get("itemlist.json?Type=topic");

    // Check if the response is successful and contains the expected data
    if (response.statusCode == 200 && response.data != null) {
      List<dynamic> items = response.data['Result']['Items']['Item'];
      var topicsList = items.map((json) => Topic.fromJson(json)).toList();
      return topicsList;
    } else {
      // Handle the case where the response is not successful
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    // Return an empty list or rethrow the error
    return []; // or throw e;
  }
}

// // Fetch topic data by ID
// Future<void> fetchTopicData(String id) async {
//   try {
//     var response = await DioHelper().get("topicsearch.json?TopicId=$id");

//     // Check if the response is successful and contains the expected data
//     if (response.statusCode == 200 && response.data != null) {
//       var data = response.data;
//       var resource = data['Result']['Resources']['Resource'];
//       print(resource); // Return the fetched data
//     } else {
//       // Handle the case where the response is not successful
//       throw Exception('Failed to load data: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//     rethrow; // Rethrow the error to handle it in the UI
//   }
// }
// Fetch topic data by ID
Future<HealthTopic> fetchTopicData(String id) async {
  try {
    var response = await DioHelper().get("topicsearch.json?TopicId=$id");

    if (response.statusCode == 200 && response.data != null) {
      var data = response.data;

      // Extract the first item from the list
      var result = data['Result']['Resources']['Resource'][0];
      // Parse the result into a HealthTopic object
      var healthTopic = HealthTopic.fromJson(result);
      return healthTopic;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    rethrow; // Rethrow the error to handle it in the UI
  }
}

String removeHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}
