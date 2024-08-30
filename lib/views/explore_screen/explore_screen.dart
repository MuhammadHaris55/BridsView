import 'dart:typed_data';
import 'dart:ui';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/search_bars_controller/search_bars_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';
import '../../model/nearby_bars_model/nearby_bars_model.dart';
import '../../widgets/custom_explore_widget/custom_explore_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Uint8List?> barsOrClubsImages = [];
  List<Results> barsOrClubsData = [];
  List<Rows> barsOrClubsDistanceList = [];
  List<Result> barsOrClubsDetail = [];

  bool isSearchBarOpen = false;
  bool isClubs = true;

  @override
  void initState() {
    super.initState();
    final searchController =
        Provider.of<SearchBarsController>(context, listen: false);
    searchController.getCordinateds();
    clearList();
    getBarsAndClubs('bar');
  }

  void clearList() {
    barsOrClubsData.clear();
    barsOrClubsImages.clear();
    barsOrClubsDistanceList.clear();
    barsOrClubsDetail.clear();
  }

  Future<void> getBarsAndClubs(String type) async {
    clearList();

    final mapController = Provider.of<MapsController>(context, listen: false);
    mapController.barsAndClubImages.clear();
    mapController.barsAndClubsDistanceList.clear();

    var data = await mapController.exploreBarsOrClubs(type);

    barsOrClubsData.addAll(data as Iterable<Results>);
    barsOrClubsImages = mapController.barsAndClubImages;
    barsOrClubsDistanceList = mapController.barsAndClubsDistanceList;

    for (var i = 0; i < barsOrClubsData.length; i++) {
      var detail =
          await mapController.barsDetailMethod(barsOrClubsData[i].reference!);
      barsOrClubsDetail.add(detail!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("Explore"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            centerTitle: true,
            title: Text(
              'Explore',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.03),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () {
                    isSearchBarOpen = true;
                    setState(() {});
                  },
                  child: Icon(Icons.search,
                      color: Colors.white, size: size.height * 0.04),
                ),
              )
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                clearList();
                                getBarsAndClubs('night_club');
                                setState(() {
                                  isClubs = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Clubs',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.03),
                                  ),
                                  Divider(
                                    color: isClubs == true
                                        ? primaryColor
                                        : Colors.white,
                                    thickness: size.height * 0.006,
                                  )
                                ],
                              ),
                            ),
                          ),
                          //
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                clearList();
                                getBarsAndClubs('bar');
                                setState(() {
                                  isClubs = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Bars',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.03),
                                  ),
                                  Divider(
                                    color: isClubs == true
                                        ? Colors.white
                                        : primaryColor,
                                    thickness: size.height * 0.006,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                      SizedBox(
                        height: size.height * 0.03,
                      ),

                      barsOrClubsData.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : isClubs == true
                              ? Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: barsOrClubsImages.length,
                                    itemBuilder: (context, index) {
                                      return CustomExploreWidget(
                                        barsOrClubsImages: barsOrClubsImages,
                                        barsOrClubsData: barsOrClubsData,
                                        barsOrClubsDistanceList:
                                            barsOrClubsDistanceList,
                                        index: index,
                                        barAndClubsDetails: barsOrClubsDetail,
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                  itemCount: barsOrClubsImages.length,
                                  itemBuilder: (context, index) {
                                    return CustomExploreWidget(
                                      barsOrClubsImages: barsOrClubsImages,
                                      barsOrClubsData: barsOrClubsData,
                                      barsOrClubsDistanceList:
                                          barsOrClubsDistanceList,
                                      index: index,
                                      barAndClubsDetails: barsOrClubsDetail,
                                    );
                                  },
                                ))
                    ],
                  ),
                  //
                  if (isSearchBarOpen)
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Consumer<SearchBarsController>(
                          builder: (context, value, child) {
                            return Container(
                              color: Colors.black.withOpacity(0.6),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customSearchBarWidget(),
                                    value.searchingBar
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          )
                                        : value.barDetail.isEmpty
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Text(
                                                  "Search Bars Or Clubs",
                                                  style: TextStyle(
                                                      color: Colors.white60),
                                                ),
                                              )
                                            : Expanded(
                                                child: ListView.builder(
                                                  itemCount: value
                                                      .searcbarsImage.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final nonNullBarDetail =
                                                        value.barDetail
                                                            .where((item) =>
                                                                item != null)
                                                            .cast<Result>()
                                                            .toList();
                                                    return CustomExploreWidget(
                                                      barsOrClubsImages:
                                                          value.searcbarsImage,
                                                      barsOrClubsDistanceList:
                                                          value
                                                              .searcbarsDistance,
                                                      index: index,
                                                      barAndClubsDetails:
                                                          nonNullBarDetail,
                                                    );
                                                  },
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              )),
        ));
  }

  Widget customSearchBarWidget() {
    return Consumer<SearchBarsController>(
      builder: (context, value, child) {
        return TextField(
          controller: value.searchTextFieldController,
          onSubmitted: (val) {
            if (val.isEmpty || isSearchBarOpen == false) {
              value.clearFields();
              setState(() {});
            } else {
              value.searchBarsOrClubs(val, context);

              setState(() {});
            }
          },
          onChanged: (val) {},
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade900,
                size: 30,
              ),
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      value.barDetail.clear();
                      value.searchTextFieldController.clear();
                      isSearchBarOpen = false;
                    });
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey.shade900,
                    size: 30,
                  ))),
        );
      },
    );
  }
}
