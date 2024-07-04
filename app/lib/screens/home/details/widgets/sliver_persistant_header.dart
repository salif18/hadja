import 'package:flutter/material.dart';
import 'package:hadja_grish/models/articles_model.dart';


class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
final ArticlesModel item;  
final double maxHeight;
final double minHeight;
   MySliverPersistentHeaderDelegate({
     required this.maxHeight, 
     required this.minHeight,
     required this.item
  });

  @override
  Widget build(BuildContext context, double shrinkOffset,bool overlapsContent) {
    return Stack(
       children: [
        Image.asset(
          item.img,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: maxHeight,
          ),
           Positioned(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 25,
                right: 25,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 5, 191, 100).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: maxHeight - minHeight - shrinkOffset,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: minHeight,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 60,
              height: 5,
              color: const Color.fromARGB(255, 5, 191, 100),
            ),
          ),
        )
       ],
    );
  }

@override
  double get maxExtent => maxHeight > minHeight ? maxHeight : minHeight;

    @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent || minHeight != oldDelegate.minExtent ;
  }
  
}