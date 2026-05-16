import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zerin_driver/features/trip/controllers/trip_controller.dart';
import 'package:zerin_driver/features/wallet/controllers/wallet_controller.dart';
import 'package:zerin_driver/helper/login_helper.dart';
import 'package:zerin_driver/util/app_constants.dart';
import 'package:zerin_driver/util/images.dart';
import 'package:zerin_driver/util/styles.dart';
import 'package:zerin_driver/features/auth/controllers/auth_controller.dart';
import 'package:zerin_driver/features/location/controllers/location_controller.dart';
import 'package:zerin_driver/features/profile/controllers/profile_controller.dart';
import 'package:zerin_driver/features/ride/controllers/ride_controller.dart';
import 'package:zerin_driver/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  const SplashScreen({super.key, this.notificationData});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if(!GetPlatform.isIOS){
      _checkConnectivity();
    }
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();

    // Wrap API calls in try-catch to handle network errors
    try {
      Get.find<SplashController>().initSharedData();
    } catch (e) {
      print('Error initializing shared data: $e');
    }

    try {
      Get.find<TripController>().rideCancellationReasonList();
    } catch (e) {
      print('Error loading ride cancellation reasons: $e');
    }

    try {
      Get.find<TripController>().parcelCancellationReasonList();
    } catch (e) {
      print('Error loading parcel cancellation reasons: $e');
    }

    try {
      Get.find<AuthController>().remainingTime();
    } catch (e) {
      print('Error getting remaining time: $e');
    }

    try {
      Get.find<WalletController>().getPaymentGetWayList();
    } catch (e) {
      print('Error loading payment methods: $e');
    }

    try {
      LoginHelper().handleIncomingLinks(widget.notificationData);
    } catch (e) {
      print('Error handling incoming links: $e');
    }
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _checkConnectivity(){
    bool isFirst = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);
      if((isFirst && !isConnected) || !isFirst && context.mounted) {
        ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(
            isConnected ? 'connected'.tr : 'no_connection'.tr,
            textAlign: TextAlign.center,
          ),
        ));

        if(isConnected) {
          LoginHelper().handleIncomingLinks(widget.notificationData);
        }
      }
      isFirst = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RideController>(builder: (rideController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return GetBuilder<LocationController>(builder: (locationController) {
            return Center(
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Image.asset(
                          Images.logo,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.appName,
                      style: textBold.copyWith(
                        fontSize: 28,
                        color: Theme.of(context).primaryColorDark,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Driver Application',
                      style: textRegular.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
      }),
    );
  }
}
