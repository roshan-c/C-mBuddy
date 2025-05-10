import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rebeal/camera/camera.dart';
import './create_log.dart';
import '../model/post.module.dart';
import '../model/user.module.dart';
import '../state/auth.state.dart';
import '../state/log.state.dart';
import 'package:rebeal/state/search.state.dart';
import 'package:rebeal/styles/color.dart';
import 'package:rebeal/pages/myprofile.dart';
import 'package:rebeal/widget/feedpost.dart';
import 'package:rebeal/widget/gridpost.dart';
import 'package:rebeal/widget/list.dart';
import '../widget/custom/rippleButton.dart';
import 'feed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  bool _isScrolledDown = false;
  bool _isGrid = false;

  @override
  void initState() {
    var authState = Provider.of<AuthState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authState.getCurrentUser();
      initPosts();
      initSearch();
      initProfile();
    });
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initPosts() {
    var logState = Provider.of<LogState>(context, listen: false);
    logState.databaseInit();
    logState.getDataFromDatabase();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isScrolledDown = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isScrolledDown = false;
      });
    }
  }

  Future _bodyView() async {
    if (_isGrid) {
      setState(() {
        _isGrid = false;
      });
    } else {
      setState(() {
        _isGrid = true;
      });
    }
  }

  int tab = 0;
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    final searchStateProvider = Provider.of<SearchState>(context);

    return Scaffold(
        extendBody: true,
        bottomNavigationBar: AnimatedOpacity(
            opacity: tab == 1 ? 0 : 1,
            duration: Duration(milliseconds: 301),
            child: Container(
                height: 150,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateLogPage()));
                        },
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 6),
                              shape: BoxShape.circle,
                            ))),
                    Container(
                      height: 40,
                    ),
                  ],
                ))),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FeedPage()));
            },
            child: Transform(
                transform: Matrix4.identity()..scale(-1.0, 1.0, -1.0),
                alignment: Alignment.center,
                child: Icon(
                  Icons.people,
                  size: 30,
                )),
          ),
          toolbarHeight: 37,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, top: 59),
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfilePage()));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                            height: 30,
                            width: 30,
                            child: CachedNetworkImage(
                                imageUrl: authState
                                        .profileUserModel?.profilePic ??
                                    "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg")))),
              )
            ],
          ),
          bottom: _isScrolledDown && tab != 1 || _isGrid
              ? null
              : TabBar(
                  onTap: (index) {
                    setState(() {
                      tab = index;
                    });
                    HapticFeedback.mediumImpact();
                  },
                  controller: _tabController,
                  isScrollable: false,
                  labelColor: Colors.white,
                  unselectedLabelColor: ReBealColor.ReBealLightGrey,
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 1,
                  tabs: [
                    FadeInUp(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Tab(
                              child: Text(
                                'My Friends',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))),
                    FadeInUp(
                        child: Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Tab(
                          child: Text(
                        'Friends',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    )),
                    FadeInUp(
                        child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Tab(
                          child: Text(
                        'Discovery',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    )),
                  ],
                ),
          elevation: 0,
          title: Image.asset(
            "assets/logo/logo.png",
            height: 100,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: FadeIn(
            child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 500),
                child: _isGrid
                    ? TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                            Consumer<LogState>(
                                builder: (context, logState, child) {
                              final List<LogModel>? list = logState.getLogLists(authState.userModel);
                              if (list == null || list.isEmpty) {
                                return Center(
                                  child: Text('No logs to display in grid', style: TextStyle(color: Colors.white)),
                                );
                              }
                              return RefreshIndicator(
                                  backgroundColor: ReBealColor.ReBealDarkGrey,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  onRefresh: _bodyView,
                                  child: GridView.builder(
                                    controller: _scrollController,
                                    itemCount: list.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2,
                                            crossAxisSpacing: 2),
                                    itemBuilder: (context, index) {
                                      return GridPostWidget(logModel: list[index]);
                                    },
                                  ));
                            }),
                            Consumer<LogState>(
                                builder: (context, logState, child) {
                              final List<LogModel>? list = logState.getLogLists(authState.userModel);
                              if (list == null || list.isEmpty) {
                                return Center(
                                  child: Text('No logs for Friends tab', style: TextStyle(color: Colors.white)),
                                );
                              }
                              return RefreshIndicator(
                                  backgroundColor: ReBealColor.ReBealDarkGrey,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  onRefresh: _bodyView,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return FeedPostWidget(logModel: list[index]);
                                    },
                                  ));
                            }),
                            Consumer<LogState>(
                                builder: (context, logState, child) {
                              final List<LogModel>? list = logState.getLogLists(null);
                              if (list == null || list.isEmpty) {
                                return Center(
                                  child: Text('No discovery logs for grid', style: TextStyle(color: Colors.white)),
                                );
                              }
                              return RefreshIndicator(
                                  backgroundColor: ReBealColor.ReBealDarkGrey,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  onRefresh: _bodyView,
                                  child: GridView.builder(
                                    controller: _scrollController,
                                    itemCount: list.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2,
                                            crossAxisSpacing: 2),
                                    itemBuilder: (context, index) {
                                      return GridPostWidget(logModel: list[index]);
                                    },
                                  ));
                            }),
                          ]
                        )
                    : TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          Consumer<LogState>(
                              builder: (context, logState, child) {
                            final List<LogModel>? list = logState.getLogList(authState.userModel);
                            if (list == null || list.isEmpty) {
                              return Center(
                                child: Text('No logs for your friends yet', style: TextStyle(color: Colors.white)),
                              );
                            }
                            return RefreshIndicator(
                                backgroundColor: ReBealColor.ReBealDarkGrey,
                                color: Colors.white,
                                strokeWidth: 2,
                                onRefresh: _bodyView,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return FeedPostWidget(logModel: list[index]);
                                  },
                                ));
                          }),
                          Consumer<SearchState>(
                              builder: (context, searchState, child) {
                            final List<UserModel>? list = searchState.userlist;
                            if (list == null || list.isEmpty) {
                              return Center(
                                  child: Text('No friends to display yet', style: TextStyle(color: Colors.white)));
                            }
                            return RefreshIndicator(
                                backgroundColor: ReBealColor.ReBealDarkGrey,
                                color: Colors.white,
                                strokeWidth: 2,
                                onRefresh: _bodyView,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return UserTilePage(user: list[index], isadded: true);
                                  },
                                ));
                          }),
                          Consumer<SearchState>(
                              builder: (context, searchState, child) {
                            final List<UserModel>? list = searchState.userlist;
                            if (list == null || list.isEmpty) {
                              return Center(
                                child: Text('No one to discover yet', style: TextStyle(color: Colors.white)),
                              );
                            }
                            return RefreshIndicator(
                                backgroundColor: ReBealColor.ReBealDarkGrey,
                                color: Colors.white,
                                strokeWidth: 2,
                                onRefresh: _bodyView,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return UserTilePage(user: list[index], isadded: false);
                                  },
                                ));
                          }),
                        ],
                      )))
    );
  }
}
