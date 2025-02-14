import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/rounded_container.dart';
import '../../cubit/workshop_edit_cubit.dart';

class BrandList extends StatelessWidget {
  const BrandList({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = context.select(
      (WorkshopEditBloc bloc) => bloc.state.brands,
    );
    final bloc = context.read<WorkshopEditBloc>();

    return Column(
      children: brands
          .map((brand) => Container(
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
                    onPressed: () => bloc.updateBrands(brand, false),
                    icon: const Icon(Icons.close_sharp),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
