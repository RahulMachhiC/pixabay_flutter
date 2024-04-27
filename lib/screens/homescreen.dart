import 'package:animate_do/animate_do.dart';
import 'package:fancy_image_loader/fancy_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interview/controller/homecontroller.dart';
import 'package:interview/size_extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeController>().fetchdata(context: context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int crossAxisCount(double maxWidth, size) {
    int width = maxWidth ~/ size;
    return width == 0 ? 1 : width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title:
              Consumer<HomeController>(builder: (context, controller, child) {
            return TextFormField(
              onChanged: (value) {
                if (value.length >= 2) {
                  controller.fetchSearchdata(context: context, value: value);
                } else if (value.isEmpty) {
                  controller.fetchdata(context: context);
                }
              },
              controller: controller.searchController,
              decoration: InputDecoration(
                suffixIcon: Visibility(
                  visible: controller.searchController.text.isNotEmpty
                      ? true
                      : false,
                  child: InkWell(
                    onTap: () {
                      controller.clearsearch(context: context);
                    },
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ),
                isDense: true,
                hintText: "Search Image",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
      ),
      body: Consumer<HomeController>(
        builder: (context, value, child) {
          if (value.isloading) {
            return Center(
                child: LoadingAnimationWidget.bouncingBall(
              color: Colors.white,
              size: 200,
            ));
          } else if (value.hit.hits != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(builder: (context, contains) {
                return AnimationLimiter(
                  child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: value.hit.hits!.length,
                      //  controller: scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 5.w,
                        crossAxisCount: crossAxisCount(contains.maxWidth, 300),
                      ),
                      itemBuilder: (context, index) {
                        // updatePalettes(
                        //   image: value.pixabayResponse!.hits
                        //       .elementAt(index)
                        //       .largeImageUrl,
                        // );
                        return AnimationConfiguration.staggeredGrid(
                          columnCount: crossAxisCount(contains.maxWidth, 300),
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ElasticInLeft(
                                          child: AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            content: Hero(
                                              tag: "image",
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: FancyImageLoader(
                                                  path: value.hit.hits!
                                                      .elementAt(index)
                                                      .largeImageUrl,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Hero(
                                  tag: "image",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        FancyImageLoader(
                                          path: value.hit.hits!
                                              .elementAt(index)
                                              .largeImageUrl,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                child: Text(
                                                  "Likes : ${value.hit.hits!.elementAt(index).likes}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                child: Text(
                                                  "Views : ${value.hit.hits!.elementAt(index).views}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
