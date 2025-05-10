import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebeal/state/auth.state.dart';
import 'package:rebeal/pages/settings.dart';
import 'package:rebeal/widget/share.dart';
import '../styles/color.dart';
import 'edit.dart';

// New Imports
import 'package:rebeal/state/log.state.dart';
import 'package:rebeal/model/post.module.dart'; // For LogModel
import 'package:rebeal/model/user.module.dart'; // For UserModel (FIX)
import 'package:rebeal/widget/gridpost.dart';   // For GridPostWidget

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    var logState = Provider.of<LogState>(context); // Get LogState

    final UserModel? currentUser = authState.userModel; // Renamed for clarity from state.profileUserModel
    List<LogModel>? userLogs;
    if (currentUser != null) {
      // Use getLogList which filters by user and is already reversed (latest first)
      // Or use feedlist and filter manually if specific order/filtering is needed here
      userLogs = logState.getLogList(currentUser);
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            actions: [
              FadeIn(
                  duration: Duration(milliseconds: 1000),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                      child: Icon(Icons.more_horiz, color: Colors.white)))
            ],
            leading: FadeIn(
                duration: Duration(milliseconds: 1000),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white))),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: FadeInRight(
                duration: Duration(milliseconds: 300),
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ))),
        body: Center(
            child: FadeInDown(
                child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 120,
                              width: 120,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 100,
                                  imageUrl: authState
                                          .profileUserModel?.profilePic ??
                                      "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg"),
                            ))),
                    Container(height: 10),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: Text(
                          authState.profileUserModel?.displayName.toString() ?? "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700),
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: Text(
                          authState.profileUserModel?.userName.toString() ?? "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    Container(height: 10),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: Text(
                          "${authState.profileUserModel?.bio ?? ""}",
                          style: TextStyle(
                              color: ReBealColor.ReBealLightGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    Container(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Logs",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    (userLogs == null || userLogs.isEmpty)
                        ? Container(
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ReBealColor.ReBealDarkGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "No logs yet. Create your first one!",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: userLogs.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              return GridPostWidget(logModel: userLogs![index]);
                            },
                          ),
                    Container(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          shareText(
                              "ReBe.al/${authState.profileUserModel?.userName!.replaceAll("@", "").toLowerCase() ?? ""}");
                        },
                        child: Text(
                          "🔗 ReBe.al/${authState.profileUserModel?.userName!.replaceAll("@", "").toLowerCase() ?? ""}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ))
          ],
        ))));
  }
}
