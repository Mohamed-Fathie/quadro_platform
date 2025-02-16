import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/widgets/rounded_container.dart';
import 'package:sizer/sizer.dart';

class DropdownMinu extends StatelessWidget {
  const DropdownMinu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final brandList = context.select<WorkshopAuthbloc, List<CarBrand>>(
      (cubit) => cubit.state.brands,
    );
    final cubit = context.read<WorkshopAuthbloc>();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownMenu<CarBrand>(
          width: 90.w,
          enableFilter: true,
          label: const Text("اختر الشركة"),
          controller: cubit.menuController,
          dropdownMenuEntries: CarBrand.values
              .where((brand) => !brandList.contains(brand))
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
          onSelected: (CarBrand? selectedBrand) {
            if (selectedBrand != null) {
              cubit.addBrands(selectedBrand);
              cubit.menuController.clear(); // Clear the text after selection
            }
          },
        ));
  }
}
