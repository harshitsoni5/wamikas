import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'placeholders.dart';


class HomeShimmerLoading extends StatefulWidget {
  const HomeShimmerLoading({super.key});

  @override
  State<HomeShimmerLoading> createState() => _HomeShimmerLoadingState();
}

class _HomeShimmerLoadingState extends State<HomeShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading List'),
        toolbarHeight: 0,
      ),
      body: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child:  const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 8.0),
              ],
            ),
          )),
    );
  }

}