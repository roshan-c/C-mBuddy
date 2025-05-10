import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:rebeal/helper/utility.dart';
import 'package:rebeal/model/user.module.dart';
import 'package:rebeal/state/app.state.dart';
import '../model/post.module.dart'; // Corrected import path

class LogState extends AppStates { // Renamed from PostState
  bool isBusy = false;
  // Removed: Map<String, List<PostModel>?> postReplyMap = {};
  // Removed: PostModel? _postToReplyModel;
  // Removed: PostModel? get postToReplyModel => _postToReplyModel;
  // Removed: set setPostToReply(PostModel model) {
  //   _postToReplyModel = model;
  // }

  List<LogModel>? _feedlist;
  dabase.Query? _feedQuery;
  List<LogModel>? _logDetailModelList; // Renamed from _postDetailModelList

  List<LogModel>? get logDetailModel => _logDetailModelList; // Renamed from postDetailModel

  List<LogModel>? get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist!.reversed);
    }
  }

  // Renamed from getPostList, removed 24-hour filter
  List<LogModel>? getLogList(UserModel? userModel) {
    if (userModel == null) {
      return null;
    }
    List<LogModel>? list;
    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        // Kept user filtering logic, removed time-based filter
        if (x.user!.userId == userModel.userId ||
            (userModel.followingList != null &&
                userModel.followingList!.contains(x.user!.userId))) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  // Renamed from getPostLists
  List<LogModel>? getLogLists(UserModel? userModel) {
    if (userModel == null) {
      return null;
    }

    List<LogModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        return true; // This logic might need further refinement based on future requirements
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  // Renamed from setFeedModel, accepts LogModel
  set setLogDetailModel(LogModel model) {
    _logDetailModelList ??= [];
    _logDetailModelList!.add(model);
    notifyListeners();
  }

  Future<bool> databaseInit() {
    try {
      if (_feedQuery == null) {
        _feedQuery = kDatabase.child("posts"); // Kept "posts" path as per Option A
        _feedQuery!.onChildAdded.listen(onLogAdded); // Renamed from onPostAdded
      }
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
      kDatabase.child('posts').once().then((DatabaseEvent event) { // Kept "posts" path
        final snapshot = event.snapshot;
        _feedlist = <LogModel>[]; // Use LogModel
        if (snapshot.value != null) {
          var map = snapshot.value as Map<dynamic, dynamic>?;
          if (map != null) {
            map.forEach((key, value) {
              var model = LogModel.fromJson(value); // Use LogModel.fromJson
              model.key = key;
              _feedlist!.add(model);
            });
            _feedlist!.sort((x, y) => DateTime.parse(x.createdAt)
                .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _feedlist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      // It's good practice to log the error or handle it more gracefully
      // print('Error fetching data: $error');
    }
  }

  // Renamed from onPostAdded
  onLogAdded(DatabaseEvent event) {
    LogModel log = LogModel.fromJson(event.snapshot.value as Map); // Use LogModel
    log.key = event.snapshot.key!;

    // The following line seems redundant as key is already assigned above.
    // log.key = event.snapshot.key!; 
    _feedlist ??= <LogModel>[];
    if ((_feedlist!.isEmpty || _feedlist!.any((x) => x.key != log.key))) {
      _feedlist!.add(log);
    }
    isBusy = false; // Should this be set to true at the start of an operation?
    notifyListeners();
  }

  // Method to add a new log
  Future<void> addLog(LogModel newLog) async {
    if (newLog.user == null || newLog.user!.userId == null) {
      print("LogState: Cannot add log, user or userId is null.");
      throw Exception("User information is missing for the log.");
    }

    isBusy = true;
    notifyListeners();
    
    try {
      String? logKey = kDatabase.child('posts').push().key;
      if (logKey == null) {
        throw Exception("Failed to generate a new key for the log.");
      }
      newLog.key = logKey;

      await kDatabase.child('posts').child(logKey).set(newLog.toJson());
    } catch (error) {
      print("Error adding log to database: $error");
      throw error;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
} 