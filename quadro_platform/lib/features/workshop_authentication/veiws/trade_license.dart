import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/widgets/workshop_auth.dart';

class TradeLicenseScreen extends StatelessWidget {
  const TradeLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkshopAuth(
      imagecallback: () {},
      describtion: "  قم برفع وثيقة سجلك التجاري من اجل المتابعة :",
      assetpath: "assets/images/workshop/business-license-1.svg",
      icontext: "تحميل الوثيقة",
    );
  }
}
