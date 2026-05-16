import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zerin_driver/features/auth/domain/enums/verification_from_enum.dart';
import 'package:zerin_driver/features/auth/screens/otp_log_in_screen.dart';
import 'package:zerin_driver/features/auth/screens/sign_up_screen.dart';
import 'package:zerin_driver/features/html/domain/html_enum_types.dart';
import 'package:zerin_driver/helper/display_helper.dart';
import 'package:zerin_driver/util/dimensions.dart';
import 'package:zerin_driver/util/images.dart';
import 'package:zerin_driver/util/styles.dart';
import 'package:zerin_driver/features/auth/controllers/auth_controller.dart';
import 'package:zerin_driver/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:zerin_driver/features/auth/screens/forgot_password_screen.dart';
import 'package:zerin_driver/features/html/screens/policy_viewer_screen.dart';
import 'package:zerin_driver/features/location/controllers/location_controller.dart';
import 'package:zerin_driver/features/profile/controllers/profile_controller.dart';
import 'package:zerin_driver/features/ride/controllers/ride_controller.dart';
import 'package:zerin_driver/features/splash/controllers/splash_controller.dart';
import 'package:zerin_driver/util/app_constants.dart';
import 'package:zerin_driver/common_widgets/button_widget.dart';
import 'package:zerin_driver/common_widgets/text_field_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    if(Get.find<AuthController>().getUserNumber().isNotEmpty){
      phoneController.text =  Get.find<AuthController>().getUserNumber();
    }
    passwordController.text = Get.find<AuthController>().getUserPassword();
    if(passwordController.text != ''){
      Get.find<AuthController>().setRememberMe();
    }
    if(Get.find<AuthController>().getLoginCountryCode().isNotEmpty){
      Get.find<AuthController>().countryDialCode = Get.find<AuthController>().getLoginCountryCode();
    }else if(Get.find<SplashController>().config!.countryCode != null){
      Get.find<AuthController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().config!.countryCode!).dialCode!;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (res, val) async {
        Get.find<BottomMenuController>().exitApp();
        return;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 60,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            GetBuilder<AuthController>(builder: (authController){
            return GetBuilder<ProfileController>(builder: (profileController) {
              return GetBuilder<RideController>(builder: (rideController) {
                return GetBuilder<LocationController>(builder: (locationController) {
                  return Center(child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Dimensions.paddingSizeSignUp),

                        // Clean Logo Section
                        Center(child: Image.asset(Images.logoWithName, height: 60)),
                        const SizedBox(height: Dimensions.paddingSizeSignUp),

                        Text(
                          'login'.tr,
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeTwenty),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          'log_in_message'.tr,
                          style: textMedium.copyWith(
                            color: Colors.grey[600],
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSignUp),

                        TextFieldWidget(
                          hintText: 'enter_your_phone'.tr,
                          inputType: TextInputType.number,
                          countryDialCode: authController.countryDialCode,
                          controller: phoneController,
                          focusNode: phoneNode,
                          autoFocus: phoneController.text.isEmpty,
                          onCountryChanged: (CountryCode countryCode){
                            authController.countryDialCode = countryCode.dialCode!;
                            authController.setCountryCode(countryCode.dialCode!);
                            FocusScope.of(context).requestFocus(phoneNode);
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        TextFieldWidget(
                          hintText: 'enter_your_password'.tr,
                          inputType: TextInputType.text,
                          prefixIcon: Images.lock,
                          inputAction: TextInputAction.done,
                          focusNode: passwordNode,
                          isPassword: true,
                          controller: passwordController,
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(children: [
                          InkWell(
                            onTap: () => authController.toggleRememberMe(),
                            child: Row(children: [
                              SizedBox(
                                width: 20.0,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  activeColor: Theme.of(context).primaryColor,
                                  value: authController.isActiveRememberMe,
                                  side: BorderSide(color: Colors.grey[400]!),
                                  onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Text(
                                'remember'.tr,
                                style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ]),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () => Get.to(()=>const ForgotPasswordScreen(from: VerificationForm.resetPassword)),
                            child: Text(
                              'forgot_password'.tr,
                              style: textMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        (authController.isLoading || authController.updateFcm ||
                            profileController.isLoading || rideController.isLoading ||
                            locationController.lastLocationLoading) ?
                        Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                        ButtonWidget(
                          buttonText: 'login'.tr,
                          onPressed: (){
                            String phone = phoneController.text;
                            String password = passwordController.text;
                            if(phone.isEmpty){
                              showCustomSnackBar('phone_is_required'.tr);
                              FocusScope.of(context).requestFocus(phoneNode);
                            }else if(!GetUtils.isPhoneNumber(authController.countryDialCode + phone)){
                              showCustomSnackBar('phone_number_is_not_valid'.tr);
                              FocusScope.of(context).requestFocus(phoneNode);
                            }else if(password.isEmpty){
                              showCustomSnackBar('password_is_required'.tr);
                              FocusScope.of(context).requestFocus(passwordNode);
                            }else if(password.length<8){
                              showCustomSnackBar('minimum_password_length_is_8'.tr);
                              FocusScope.of(context).requestFocus(passwordNode);
                            }else{
                              authController.login(authController.countryDialCode,phone, password);
                            }
                          },
                        ),

                        if(Get.find<SplashController>().config?.driverLoginOptions?.otpLogin ?? false)...[
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Center(
                            child: TextButton(
                              onPressed: () => Get.to(() => const OtpLoginScreen(fromSignIn: true)),
                              child: Text(
                                'login_with_otp'.tr,
                                style: textMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        (Get.find<SplashController>().config!.selfRegistration != null &&
                            Get.find<SplashController>().config!.selfRegistration!) ?
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            '${'do_not_have_an_account'.tr} ',
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>  Get.to(()=> const SignUpScreen()),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, minimumSize: const Size(50,30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'sign_up'.tr,
                              style: textMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ]) :
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            "${'to_create_account'.tr} ",
                            style: textRegular.copyWith(color: Colors.grey[600]),
                          ),
                          InkWell(
                            onTap: ()=>
                                Get.find<SplashController>().sendMailOrCall(
                                  "tel:${Get.find<SplashController>().config?.businessContactPhone}",
                                  false,
                                ),
                            child: Text(
                              "${'contact_support'.tr} ",
                              style: textRegular.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Center(
                          child: TextButton(
                            onPressed: ()=> Get.to(()=> const PolicyViewerScreen(htmlType: HtmlType.termsAndConditions)),
                            child: Text(
                              "terms_and_condition".tr,
                              style: textMedium.copyWith(
                                color: Colors.grey[500],
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                        ),

                      ]),
                    ),
                  )); 
                });
              });
            });
          }),
        ]),
        ),
      ),
    );
  }
}
