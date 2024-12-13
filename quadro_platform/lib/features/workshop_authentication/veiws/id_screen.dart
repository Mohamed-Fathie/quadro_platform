import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/widgets/workshop_auth.dart';

class IdScreen extends StatelessWidget {
  const IdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkshopAuth(
      imagecallback: () {},
      describtion: "  قم برفع بطاقة هويتك من اجل المتابعة :",
      assetpath: "assets/images/workshop/id-card-svgrepo-com.svg",
      icontext: "تحميل الهوية",
    );
  }
}
