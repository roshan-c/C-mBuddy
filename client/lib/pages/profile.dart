// ignore_for_file: deprecated_member_use, unnecessary_null_comparison
import 'dart:ui';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rebeal/state/profile.state.dart';
import 'package:rebeal/styles/color.dart';
import 'package:share_plus/share_plus.dart';

import '../model/user.module.dart';
// New Imports
import 'package:rebeal/state/log.state.dart';
import 'package:rebeal/model/post.module.dart'; // For LogModel
import 'package:rebeal/widget/gridpost.dart';   // For GridPostWidget

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.profileId, this.scaffoldKey})
      : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;

  final String profileId;
  static PageRouteBuilder getRoute({required String profileId}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Provider(
          create: (_) => ProfileState(profileId),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => ProfileState(profileId),
            builder: (_, child) => ProfilePage(
              profileId: profileId,
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isMyProfile = false;
  int pageIndex = 0;
  int counter = 3;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  double rateScroll = 0;
  double opacity = -5;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authstate = Provider.of<ProfileState>(context, listen: false);
      setState(() {
        isMyProfile = authstate.isMyProfile;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isFollower() {
    var authstate = Provider.of<ProfileState>(context, listen: false);
    if (authstate.profileUserModel?.followersList != null &&
        authstate.profileUserModel!.followersList!.isNotEmpty) {
      return (authstate.profileUserModel!.followersList!
          .any((x) => x == authstate.userId));
    } else {
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  void _shareText(String name) {
    Share.share(
      "https://rebe.al/$name",
      subject: "Discover $name on ReBeal.",
      sharePositionOrigin: Rect.fromLTWH(0, 0, 10, 10),
    );
  }

  Widget floatingButton() {
    return rateScroll >= -855
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 35),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.animateTo(0,
                            duration: Duration(seconds: 2),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: Container(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                        child: Icon(
                          FontAwesomeIcons.angleUp,
                        )),
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    var profileState = Provider.of<ProfileState>(context);
    var logState = Provider.of<LogState>(context);

    List<LogModel>? profileUserLogs;
    if (!profileState.isbusy && profileState.profileUserModel != null && logState.feedlist != null) {
      profileUserLogs = logState.feedlist!
          .where((log) => log.user?.userId == profileState.profileUserModel!.userId)
          .toList().reversed.toList();
    }

    return profileState.isbusy || profileState.profileUserModel == null
        ? Center(child: CircularProgressIndicator(color: Colors.white))
        : WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                floatingActionButton: floatingButton(),
                key: scaffoldKey,
                backgroundColor: Colors.black,
                body: NestedScrollView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverAppBar(
                          leading: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
                                size: 30,
                              )),
                          actions: [
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(
                              width: 10,
                            ),
                          ],
                          centerTitle: true,
                          pinned: true,
                          stretch: true,
                          elevation: 0,
                          onStretchTrigger: () {
                            return Future<void>.value();
                          },
                          title: Text(profileState.profileUserModel!.userName!
                              .replaceAll("@", "")),
                          backgroundColor: Colors.black.withOpacity(0),
                          expandedHeight:
                              MediaQuery.of(context).size.height / 2.2,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            stretchModes: const <StretchMode>[
                              StretchMode.zoomBackground,
                            ],
                            centerTitle: true,
                            expandedTitleScale: 3,
                            titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            background: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  padding: const EdgeInsets.only(top: 0),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: profileState
                                              .profileUserModel!.profilePic ??
                                          "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 150),
                                  child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.9)
                                          ]))),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top:
                                              MediaQuery.of(context).size.height /
                                                  2.25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            profileState
                                                .profileUserModel!.displayName!,
                                            style: TextStyle(
                                              fontFamily: 'Outfit',
                                              fontSize: 38,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.96,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    profileState.profileUserModel!.bio ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.96,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                              isMyProfile
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, right: 20, left: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          profileState.followUser(
                                              removeFollower: isFollower());
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                                color: isFollower()
                                                    ? ReBealColor
                                                        .ReBealDarkGrey
                                                    : Colors.white,
                                                height: 45,
                                                width:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.1,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  isFollower()
                                                      ? 'Unfollow'
                                                      : 'Follow',
                                                  style: TextStyle(
                                                    color: isFollower()
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                )))));
                              Container(
                                height: 7,
                              ),
                              isMyProfile
                                  ? Container()
                                  : isFollower()
                                      ? Container()
                                      : Text(
                                          'Add you\'re true friends on ReBeal.',
                                          style: TextStyle(
                                            color: ReBealColor.ReBealLightGrey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                              isMyProfile
                                  ? Container()
                                  : isFollower()
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20, left: 20),
                                              child: Text(
                                                'COMMON FRIENDS ()',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 231, 231, 231),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 100,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [],
                                                ))
                                          ],
                                        )
                            ],
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (profileUserLogs == null || profileUserLogs.isEmpty)
                          ? Center(
                              child: Text(
                                "This user hasn't posted any logs yet.",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: profileUserLogs.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return GridPostWidget(logModel: profileUserLogs![index]);
                              },
                            ),
                    )
                )
            )
        );
  }
}

class Choice {
  const Choice(
      {required this.title, required this.icon, this.isEnable = false});
  final bool isEnable;
  final IconData icon;
  final String title;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Share', icon: Icons.directions_car, isEnable: true),
  Choice(title: 'QR code', icon: Icons.directions_railway, isEnable: true),
];
