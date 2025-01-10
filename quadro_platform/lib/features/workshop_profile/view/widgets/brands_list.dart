import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

class BrandsList extends StatelessWidget {
  final List<CarBrand> brandlist;
  const BrandsList({super.key, required this.brandlist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: brandlist
            .map(
              (e) => RoundedContainer(
                width: 25.w,
                height: 18.h,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        e.svgPath,
                      ),
                      Text(
                        e.toArabic(),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
