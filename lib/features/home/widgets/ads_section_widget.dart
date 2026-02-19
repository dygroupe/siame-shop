import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AdsSectionWidget extends StatelessWidget {
  const AdsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Background color layer
            Container(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),

            // Decorative shapes (kept behind content)
            const Positioned(
              top: 0,
              right: 0,
              child: CustomAssetImageWidget(
                Images.adsRoundShape,
                height: 100,
                width: 100,
                color: Colors.white,
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              child: CustomAssetImageWidget(
                Images.adsCurveShape,
                height: 110,
                width: 110,
                color: Colors.white,
              ),
            ),

            // Foreground content
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'want_to_get_highlighted'.tr,
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Text(
                                'in_the_customer_app_and_websites'.tr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: const CustomAssetImageWidget(Images.adsImage, height: 85, width: 98),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 140,
                      child: CustomButtonWidget(
                        buttonText: 'create_ads'.tr,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSizeDefault,
                        onPressed: () {
                          Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

