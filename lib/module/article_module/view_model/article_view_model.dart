import 'dart:async';

import 'package:Coretext/module/article_module/model/article_analytics_data_model.dart';
import 'package:Coretext/module/article_module/model/article_data_model.dart';
import 'package:Coretext/module/article_module/view_model/article_analytics_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleViewModel extends GetxController {
  // Observable for articles
  Rx<APIBaseModel<List<ArticleDataModel?>?>?> articleListDataModel =
      RxNullable<APIBaseModel<List<ArticleDataModel?>?>?>().setNull();

  Rx<APIBaseModel<ArticleDataModel?>?> articleDataModel =
      RxNullable<APIBaseModel<ArticleDataModel?>?>().setNull();

  Rx<APIBaseModel<List<ArticleDataModel?>?>?> articleByCategory =
      RxNullable<APIBaseModel<List<ArticleDataModel?>?>?>().setNull();

  Rx<APIBaseModel<List<ArticleDataModel?>?>?> articleByMyCatId =
      RxNullable<APIBaseModel<List<ArticleDataModel?>?>?>().setNull();

  Rx<APIBaseModel<List<ArticleDataModel?>?>?> getBookMarkByid =
      RxNullable<APIBaseModel<List<ArticleDataModel?>?>?>().setNull();

  ArticleAnalyticsViewModel articleAnalyticsViewModel =
      Get.put(ArticleAnalyticsViewModel());

  bool isProcessing = false;

  var isApiCalled = false.obs; // Rx variable to track if API has been called
  Timer? _viewTimer; // Timer to track time spent on the article
  int? currentArticleIndex; // Store the current article index
  var articlesLoaded = false.obs;

  var bookmarkedArticles = <int>[].obs;
  var favoriteArticles = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarkedArticles(); // Load bookmarks when the controller is initialized
  }

  // Method to add or remove an index from favoriteArticles
  void updateArticle(ArticleDataModel? article) {
    if (article != null) {
      int index =
          articleListDataModel.value?.responseBody?.indexOf(article) ?? -1;
      if (index != -1) {
        articleListDataModel.value?.responseBody![index] = article;
        // Notify listeners
        articleListDataModel.refresh(); // Trigger refresh
      }
    }
  }

  // Method to fetch articles from API with fallback to static data
  Future<APIBaseModel<List<ArticleDataModel?>?>?> getArticles() async {
    try {
      articleListDataModel.value = await APIService
          .getDataFromServerWithoutErrorModel<List<ArticleDataModel?>?>(
        endPoint: articleBatchEndPoint, //articleEndPoint,
        create: (dynamic json) {
          return (json as List)
              .map((e) => ArticleDataModel.fromJson(e))
              .toList();
        },
      );
    } catch (e) {}

    return articleListDataModel.value;
  }

  //artcle details
  Future<APIBaseModel<ArticleDataModel?>?> getArticleDetails({
    required int articleId,
  }) async {
    articleDataModel.value =
        await APIService.getDataFromServer<ArticleDataModel?>(
      endPoint: articleDetailsEndPoint(
        articleID: articleId,
      ),
      create: (dynamic json) {
        try {
          return ArticleDataModel.fromJson(json);
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    return articleDataModel.value;
  }

  Future<APIBaseModel<List<ArticleDataModel?>?>?> getArticlesByCategory({
    required int catId,
  }) async {
    try {
      articleByCategory.value = await APIService
          .getDataFromServerWithoutErrorModel<List<ArticleDataModel?>?>(
        endPoint: articleByCatId(catID: catId),
        create: (dynamic json) {
          return (json as List)
              .map((e) => ArticleDataModel.fromJson(e))
              .toList();
        },
      );
    } catch (e) {}

    return articleByCategory.value;
  }

  // Future<APIBaseModel<List<ArticleDataModel?>?>?> getArticlesByMyCatId({
  //   required List<int> catIds,
  // }) async {
  //   try {
  //     articleByMyCatId.value = await APIService
  //         .getDataFromServerWithoutErrorModel<List<ArticleDataModel?>?>(
  //       endPoint: articleMyCatId(catId: catIds),
  //       create: (dynamic json) {
  //         return (json as List)
  //             .map((e) => ArticleDataModel.fromJson(e))
  //             .toList();
  //       },
  //     );
  //   } catch (e) {}

  //   return articleByMyCatId.value;
  // }

// Load bookmarked articles from local storage
  Future<void> loadBookmarkedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve stored bookmarks as a List<String>
    List<String>? storedBookmarks = prefs.getStringList('bookmarkedArticles');

    // If there are stored bookmarks, convert them to List<int> (article IDs)
    if (storedBookmarks != null && storedBookmarks.isNotEmpty) {
      bookmarkedArticles.value = storedBookmarks.map(int.parse).toList();
    } else {
      bookmarkedArticles.value =
          []; // Set to an empty list if no bookmarks found
    }
  }

// Toggle bookmark state and store in local storage
  Future<void> toggleBookmark(int articleId) async {
    if (bookmarkedArticles.contains(articleId)) {
      // If already bookmarked, remove it
      bookmarkedArticles.remove(articleId);
    } else {
      // If not bookmarked, add it
      bookmarkedArticles.add(articleId);
    }

    // Save updated bookmarks to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList =
        bookmarkedArticles.map((item) => item.toString()).toList();
    await prefs.setStringList('bookmarkedArticles', stringList);
    update();
  }

// Print stored bookmarks from local storage
  Future<void> printStoredBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedBookmarks = prefs.getStringList('bookmarkedArticles');
    print("Stored Bookmarks: $storedBookmarks");
  }

  Future<void> getBookmarkedArticlesFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve stored bookmarks as a List<String>
    List<String>? storedBookmarks = prefs.getStringList('bookmarkedArticles');

    if (storedBookmarks != null && storedBookmarks.isNotEmpty) {
      // Convert the List<String> to List<int> (article IDs)
      List<int> articleIds = storedBookmarks.map(int.parse).toList();

      // Pass the articleIds to your getBookMarkById method
      await getBookMarkById(articleIds: articleIds);
    } else {
      print("No bookmarked articles found.");

      // Clear the previously displayed articles
      getBookMarkByid.value = null; // or any method to clear previous data
      // Additionally, if you're displaying these articles in a UI component,
      // you should refresh that component to show the updated state.
      // e.g., myArticles.refresh();
    }
  }

  Future<APIBaseModel<List<ArticleDataModel?>?>?> getBookMarkById({
    required List<int> articleIds,
  }) async {
    try {
      getBookMarkByid.value = await APIService
          .getDataFromServerWithoutErrorModel<List<ArticleDataModel?>?>(
        endPoint: bookMarkedArticle(articleIds: articleIds),
        create: (dynamic json) {
          return (json as List)
              .map((e) => ArticleDataModel.fromJson(e))
              .toList();
        },
      );
    } catch (e) {}

    return getBookMarkByid.value;
  }
  // Method to toggle bookmark state
  // void toggleBookmark(int index) {
  //   if (bookmarkedArticles.contains(index)) {
  //     bookmarkedArticles.remove(index);
  //   } else {
  //     bookmarkedArticles.add(index);
  //   }
  // }

  // Toggle favorite state
  // void toggleFavorite(int index) {
  //   if (favoriteArticles.contains(index)) {
  //     favoriteArticles.remove(index);
  //   } else {
  //     favoriteArticles.add(index);
  //   }

  //   update();
  // }
  // Add this flag to prevent multiple rapid taps

  void toggleFavorite(int index, ArticleDataModel article) async {
    // Prevent multiple taps to avoid rapid toggling
    if (isProcessing) return;

    // Start processing
    isProcessing = true;

    try {
      if (article.isLike == 1) {
        // Handle 'unlike' case
        article.isLike = 0; // Mark as not liked
        article.likes = (article.likes != null && article.likes! > 0)
            ? article.likes! - 1
            : 0; // Ensure likes count doesn’t go below zero

        // Remove from favorites list
        favoriteArticles.remove(index);

        // Call analytics for 'unlike'
        await articleAnalyticsViewModel.articleAnalyticsForLikeShareCount(
          articleId: article.id,
          type: "unlike",
        );
      } else {
        // Handle 'like' case
        article.isLike = 1; // Mark as liked
        article.likes = (article.likes ?? 0) + 1; // Increase likes count

        // Add to favorites list
        favoriteArticles.add(index);

        // Call analytics for 'like'
        await articleAnalyticsViewModel.articleAnalyticsForLikeShareCount(
          articleId: article.id,
          type: "like",
        );
      }
    } catch (e) {
      // Log or handle the error if needed
      print("Error in toggleFavorite: $e");
    } finally {
      // Release the processing lock
      isProcessing = false;
      update(); // Notify listeners to refresh UI
    }
  }

  String formatDate(String isoDate) {
    try {
      // Parse the ISO 8601 date string
      DateTime dateTime = DateTime.parse(isoDate);

      // Define the desired format
      DateFormat formatter = DateFormat('MMMM yyyy');

      // Format the date
      return formatter.format(dateTime);
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing date: $e');
      return '';
    }
  }

// convert count in k and m series
  String formatCount(int count) {
    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}m"; // Display in millions (1.5m)
    } else if (count >= 1000) {
      return "${(count / 10).toStringAsFixed(1)}k"; // Display in thousands (1.5k)
    } else {
      return count.toString(); // Display the count as is if less than 1000
    }
  }

  // Function to start the view timer
  // Function to start the view timer
  void startViewTimer(int index, ArticleDataModel? article) {
    // Ensure the article is valid and the index changes before starting the timer
    if (article == null) {
      print("Article is null, cannot start the timer.");
      return;
    }

    if (currentArticleIndex != index) {
      currentArticleIndex = index;

      // Reset the API call flag and cancel any previous timer
      isApiCalled.value = false;
      _viewTimer?.cancel(); // Cancel any ongoing timer

      // Start a new timer for the current article
      _viewTimer = Timer(Duration(seconds: 2), () {
        if (!isApiCalled.value) {
          article.itemType == "ad"
              ? articleAnalyticsViewModel.adAnalytics(
                  adId: article.id, type: "view")
              : article.itemType == "article"
                  ?
                  // Call the analytics API to track the view event after 2 seconds
                  articleAnalyticsViewModel.articleAnalyticsForLikeShareCount(
                      articleId: article.id,
                      type: "view", // Track as a 'view' event
                    )
                  : null;
          isApiCalled.value = true; // Set the flag to true after the API call
        }
      });
    }
  }

  // Cancel the timer when the controller is disposed
  @override
  void onClose() {
    _viewTimer?.cancel();
    super.onClose();
  }

  void reset() {
    articleListDataModel.value = null; // Reset to null
    articleDataModel.value = null; // Reset to null
    articleByCategory.value = null; // Reset to null
    articleByMyCatId.value = null; // Reset to null
    getBookMarkByid.value = null;
    update(); // Reset to null

    // Optionally, re-initialize with empty lists if needed
    // articleListDataModel.value = APIBaseModel<List<ArticleDataModel>>(...);
  }
}
