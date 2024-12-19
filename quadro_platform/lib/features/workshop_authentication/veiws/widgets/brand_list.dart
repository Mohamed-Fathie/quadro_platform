import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';

class BrandList extends StatelessWidget {
  const BrandList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkshopAuthbloc>();
    final brandList = context.select<WorkshopAuthbloc, List<CarBrand>>(
      (cubit) => cubit.state.brands,
    );

    return Column(
      children: brandList.map((brand) {
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
              onPressed: () => cubit.deleteBrand(brand),
              icon: const Icon(Icons.close_sharp),
            ),
          ),
        );
      }).toList(),
    );
  }
}
