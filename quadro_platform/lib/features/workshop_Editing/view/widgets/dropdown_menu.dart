import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/car_brands.dart';
import '../../../../shared/widgets/rounded_container.dart';
import '../../cubit/workshop_edit_cubit.dart';

class DropdownMinu extends StatelessWidget {
  const DropdownMinu({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = context.select(
      (WorkshopEditBloc bloc) => bloc.state.brands,
    );
    final bloc = context.read<WorkshopEditBloc>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownMenu<CarBrand>(
        width: 90.w,
        enableFilter: true,
        label: const Text("اختر الشركة"),
        dropdownMenuEntries: CarBrand.values
            .where((brand) => !brands.contains(brand))
            .map<DropdownMenuEntry<CarBrand>>((brand) {
          return DropdownMenuEntry<CarBrand>(
            value: brand,
            label: brand.toArabic(),
            leadingIcon: RoundedContainer(
              height: 50,
              width: 50,
              child: Image.asset(brand.svgPath),
            ),
            labelWidget: Text(
              brand.toArabic(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        }).toList(),
        onSelected: (brand) {
          if (brand != null) {
            bloc.updateBrands(brand, true);
          }
        },
      ),
    );
  }
}
