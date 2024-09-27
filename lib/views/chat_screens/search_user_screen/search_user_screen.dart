import 'dart:developer';
import 'dart:ui';
import 'package:badges/badges.dart' as badges;
import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/chat_screens/friend_request_screen/friend_request_screen.dart';
import 'package:birds_view/widgets/custom_chat_screen_widgets/custom_chats/custom_chat.dart';
import 'package:birds_view/widgets/custom_chat_screen_widgets/custom_groups/custom_groups.dart';
import 'package:birds_view/widgets/custom_chat_screen_widgets/custom_my_friends/custom_my_friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  final UserModel? userModel;
  const SearchUserScreen({super.key, required this.userModel});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  bool isSearchBarOpen = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCredentials();
    });

    log("----------------");
  }

  Future<void> getCredentials() async {
    final chatController = Provider.of<ChatController>(context, listen: false);
    await chatController.getUserCredential();
    await chatController.fetchFriendList();
    await chatController.getFriendRequestCount();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: AssetImage(whiteLogo),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: FriendRequestScreen(
                        user: widget.userModel,
                      ),
                      type: PageTransitionType.fade));
            }, child: Consumer<ChatController>(
              builder: (context, value, child) {
                return value.friendReqCount == 0 ? Icon(
                    CupertinoIcons.person_2,
                    color: whiteColor,
                  )
                : badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  badgeContent: Text(
                    value.friendReqCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: Icon(
                    CupertinoIcons.person_2,
                    color: whiteColor,
                  ),
                );
              },
            )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<ChatController>(
          builder: (context, value, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        onTap: () async {
                          await value.getUserCredential();
                          setState(() {
                            isSearchBarOpen =
                                true; // Correctly using setState here
                          });
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            fillColor: const Color(0xff252525),
                            filled: true,
                            prefixIcon: const Icon(CupertinoIcons.search),
                            prefixIconColor: Colors.white,
                            hintText: "Search Friends",
                            hintStyle: TextStyle(
                                color: whiteColor.withOpacity(0.9),
                                fontSize: 14)),
                      ),
                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SizedBox(
                          width: size.width,
                          child: Divider(
                            color: whiteColor.withOpacity(0.5),
                            thickness: 1,
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              value.handleMyFriends();
                            },
                            child: Column(
                              children: [
                                Text("My Friends",
                                    style: GoogleFonts.urbanist(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.022)),
                                SizedBox(height: size.height * 0.01),
                                value.myFriends
                                    ? Container(
                                        height: 3,
                                        width: size.width / 4,
                                        decoration: BoxDecoration(
                                            gradient: gradientColor))
                                    : SizedBox(height: 3, width: size.width / 4)
                              ],
                            ),
                          ),
                          // Repeat for Chats and Groups...
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),

                      if (value.myFriends) ...[
                        if (value.friendsList.isEmpty)
                          Container()
                        else
                          for (var i = 0;
                              i < value.friendsList.length;
                              i++) ...[
                            CustomMyFriends(
                                index: i, friendModel: value.friendsList),
                          ]
                      ],

                      if (value.chats) const CustomChat(),
                      if (value.groups) const CustomGroups(),
                    ],
                  ),
                ),
                if (isSearchBarOpen)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                onSubmitted: (val) {
                                  value.searchUser();
                                },
                                style: TextStyle(color: whiteColor),
                                controller: value.searchController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  fillColor: const Color(0xff252525),
                                  filled: true,
                                  prefixIcon: const Icon(CupertinoIcons.search),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSearchBarOpen = false;
                                        value.searchController.clear();
                                        value.firebaseUserModel!.clear();
                                      });
                                    },
                                    child: Icon(Icons.cancel_outlined,
                                        color: whiteColor),
                                  ),
                                  prefixIconColor: Colors.white,
                                  hintText: "Search Friends",
                                  hintStyle: TextStyle(
                                      color: whiteColor, fontSize: 14),
                                ),
                              ),
                              if (value.firebaseUserModel!.isEmpty)
                                Container()
                              else if (value.isSearching)
                                Center(
                                    child: CircularProgressIndicator(
                                        color: primaryColor))
                              else
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: value.firebaseUserModel!.length,
                                    itemBuilder: (context, index) {
                                      final user =
                                          value.firebaseUserModel![index];

                                      return FutureBuilder<List<bool>>(
                                        future: Future.wait([
                                          value.isFriend(user.id!),
                                          value.hasSentRequest(user.id!),
                                        ]),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: primaryColor));
                                          }

                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          final isFriend = snapshot.data![0];
                                          final hasSentRequest =
                                              snapshot.data![1];

                                          return SizedBox(
                                            width: size.width * 0.9,
                                            height: 200,
                                            child: ListTile(
                                              leading: const CircleAvatar(),
                                              title: Text(user.firstName!,
                                                  style: GoogleFonts.urbanist(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.height * 0.02)),
                                              subtitle: Text(user.email!,
                                                  style: GoogleFonts.urbanist(
                                                      color: Colors.white)),
                                              trailing: isFriend ||
                                                      hasSentRequest
                                                  ? const SizedBox.shrink()
                                                  : CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          whiteColor
                                                              .withOpacity(0.4),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          value.sendFriendRequest(
                                                              value
                                                                  .firebaseUserModel!,
                                                              index);
                                                        },
                                                        child: Icon(Icons.add,
                                                            color: whiteColor,
                                                            size: 15),
                                                      ),
                                                    ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}