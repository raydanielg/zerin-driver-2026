import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zerin_driver/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:zerin_driver/helper/login_helper.dart';
import 'package:zerin_driver/util/dimensions.dart';
import 'package:zerin_driver/util/images.dart';
import 'package:zerin_driver/util/styles.dart';
import 'package:zerin_driver/features/auth/controllers/auth_controller.dart';
import 'package:zerin_driver/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:zerin_driver/features/dashboard/screens/dashboard_screen.dart';
import 'package:zerin_driver/features/location/controllers/location_controller.dart';
import 'package:zerin_driver/common_widgets/button_widget.dart';
import 'package:zerin_driver/common_widgets/loader_widget.dart';


class AccessLocationScreen extends StatelessWidget {
  const AccessLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: PopScope(canPop: false,
          onPopInvokedWithResult: (res, val) async {
            Get.find<BottomMenuController>().exitApp();
            return;
          },
          child: Center(
           child: GetBuilder<LocationController>(builder: (locationController) {
             return Column(children: [
               Expanded(child: SizedBox(width:Dimensions.webMaxWidth,
                 child: Center(child: Center(child: SizedBox(width: 700,
                     child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(Images.mapLocationIcon, height: 240),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text('find_customer_near_you'.tr, textAlign: TextAlign.center,
                          style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                              color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),),

                        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Text('please_select_you_location_to_start_finding_available_customer_near_you'.tr,
                                textAlign: TextAlign.center, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                    color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor))),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            const BottomButton()])))))),
             ],
             );
           }
           ),
          ),
        )
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width-40 ,
        child: Column(children: [
          ButtonWidget(buttonText: 'use_current_location'.tr,
            fontSize: Dimensions.fontSizeSmall,
            onPressed: () async {
              Get.dialog(
                const BackgroundLocationDisclosureDialog(),
                barrierDismissible: false,
              );
            }, icon: Icons.my_location,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ])));
  }
}

class BackgroundLocationDisclosureDialog extends StatelessWidget {
  const BackgroundLocationDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.location_on, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Text('location_permission_title'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'location_permission_description'.tr,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),
            _buildBulletPoint(context, 'location_bullet_1'.tr),
            const SizedBox(height: 8),
            _buildBulletPoint(context, 'location_bullet_2'.tr),
            const SizedBox(height: 8),
            _buildBulletPoint(context, 'location_bullet_3'.tr),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'location_warning'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.find<BottomMenuController>().exitApp();
          },
          child: Text('cancel'.tr, style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            Get.find<LocationController>().checkPermission().then((permission){
              if(permission){
                Get.dialog(const LoaderWidget(), barrierDismissible: false);
                Get.find<LocationController>().getCurrentLocation().then((value){
                  Get.back();
                  if(value.latitude != 0 && value.longitude != 0){
                    if(Get.find<AuthController>().isLoggedIn()){
                      Get.find<OutOfZoneController>().getZoneList();
                      Get.offAll(()=> const DashboardScreen());
                    }else{
                      LoginHelper.checkLoginMedium();
                    }
                  }
                });
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text('i_agree'.tr, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }
}

