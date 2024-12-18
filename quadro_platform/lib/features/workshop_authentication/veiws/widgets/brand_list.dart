import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';

class BrandList extends StatelessWidget {
  final List<CarBrand> brands;
  final Function(CarBrand) onDelete;

  const BrandList({required this.brands, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: brands.map((brand) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Qcolors.buttonbackground,
          ),
          child: ListTile(
            leading: RoundedContainer(
              height: 50,
              width: 50,
              child: Image.asset(brand.svgPath),
            ),
            title: Text(
              brand.toArabic(),
              style: const TextStyle(color: Qcolors.primarycolor),
            ),
            trailing: IconButton(
              iconSize: 40,
              color: Qcolors.primarycolor,
              onPressed: () => onDelete(brand),
              icon: const Icon(Icons.close_sharp),
            ),
          ),
        );
      }).toList(),
    );
  }
}
