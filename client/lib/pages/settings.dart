import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebeal/helper/utility.dart';
import 'package:rebeal/state/auth.state.dart';
import 'package:rebeal/styles/color.dart';
import 'package:share_plus/share_plus.dart';

import 'edit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Helper method to create styled list items for settings
  Widget _buildSettingsItem(
      {required IconData icon, required String title, required VoidCallback onTap, Color? titleColor}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 60, // Standardized height
          width: MediaQuery.of(context).size.width,
          color: ReBealColor.ReBealDarkGrey,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  SizedBox(width: 15),
                  Text(
                    title,
                    style: TextStyle(
                        color: titleColor ?? Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: ReBealColor.ReBealLightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
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
                  "Settings",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ))),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            color: ReBealColor.ReBealDarkGrey,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: 65,
                                          width: 65,
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              height: 100,
                                              imageUrl: state.profileUserModel
                                                      ?.profilePic ??
                                                  "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg"),
                                        )),
                                    SizedBox(width: 10),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${state.profileUserModel?.displayName ?? "User"}\n',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${state.profileUserModel?.userName ?? "@username"}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ReBealColor.ReBealLightGrey,
                                  size: 15,
                                )
                              ],
                            )))),
                SizedBox(height: 30),
                Text(
                  "Preferences",
                  style: TextStyle(color: Color.fromARGB(255, 90, 90, 90), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                _buildSettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Account Privacy",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account Privacy settings not yet implemented.')),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: "Notification Preferences",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification Preferences not yet implemented.')),
                    );
                  },
                ),
                SizedBox(height: 30),
                Text(
                  "About",
                  style: TextStyle(color: Color.fromARGB(255, 90, 90, 90), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                _buildSettingsItem(
                  icon: CupertinoIcons.share,
                  title: "Share ReBeal",
                  onTap: () {
                     Share.share(
                        "rebe.al/${state.profileUserModel?.userName?.replaceAll("@", "").toLowerCase() ?? "profile"}",
                        subject: "Add me on ReBeal.",
                        sharePositionOrigin: Rect.fromLTWH(0, 0, 10, 10),
                      );
                  }
                ),
                SizedBox(height: 30),
                _buildSettingsItem(
                  icon: Icons.logout,
                  title: "Log out",
                  titleColor: Colors.red,
                  onTap: () {
                      state.logoutCallback();
                      // Pop twice if settings is on top of profile which is on top of home
                      if(Navigator.canPop(context)) Navigator.pop(context);
                      if(Navigator.canPop(context)) Navigator.pop(context);
                  }
                ),
                SizedBox(height: 20),
                Text(
                  "Version 1.0.0 (1) - Clone Version",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 96, 96, 96),
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
                SizedBox(height: 10),
                Text(
                  "You joined BeReal ${Utility.getdob(state.profileUserModel?.createAt?.toString() ?? DateTime.now().toIso8601String())}", // Added null checks
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
                SizedBox(height: 40), // Ensure content doesn't hide behind bottom nav if any
              ],
            )));
  }
}
