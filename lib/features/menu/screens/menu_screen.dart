import 'package:sixam_mart_store/features/auth/domain/models/module_permission_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/menu/domain/models/menu_model.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/features/menu/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Store? store = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.stores![0] : null;
    ModulePermissionModel? modulePermission = Get.find<ProfileController>().modulePermission;

    final List<MenuModel> menuList = [];

    menuList.add(MenuModel(icon: '', title: 'edit_profile'.tr, route: RouteHelper.getUpdateProfileRoute()));

    if(modulePermission!.item!) {
      menuList.add(MenuModel(
        icon: Images.addFood, title: 'all_items'.tr, route: RouteHelper.getAllItemsRoute(),
        isBlocked: !store!.itemSection!,
      ));
    }

    if(modulePermission.item!) {
      menuList.add(MenuModel(
        icon: Images.pendingItemIcon, title: 'pending_item'.tr, route: RouteHelper.getPendingItemRoute(),
      ));
    }

    if(modulePermission.storeSetup!) {
      menuList.add(MenuModel(icon: Images.settingIcon, title: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurant_config'.tr : 'store_config'.tr, route: RouteHelper.getStoreSettingsRoute(store!)));
    }

    if(modulePermission.category!) {
      menuList.add(MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()));
    }

    if(modulePermission.banner!) {
      menuList.add(MenuModel(icon: Images.bannerIcon, title: 'banner'.tr, route: RouteHelper.getBannerListRoute()));
    }

    if(modulePermission.advertisementList!){
      menuList.add(MenuModel(icon: Images.adsMenu, title: 'advertisements'.tr, route: RouteHelper.getAdvertisementListRoute()));
    }

    if(modulePermission.campaign!) {
      menuList.add(MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()));
    }

    if(modulePermission.deliveryman! || modulePermission.deliverymanList!){
      if(store?.selfDeliverySystem == 1 && store?.storeBusinessModel != 'subscription') {
        menuList.add(MenuModel(icon: Images.deliveryMan, iconColor: Colors.white, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute()));
      } else if(store?.selfDeliverySystem == 1 && store?.storeBusinessModel == 'subscription' && (Get.find<ProfileController>().profileModel!.subscription!.selfDelivery == 1)) {
        menuList.add(MenuModel(
          icon: Images.deliveryMan, iconColor: Colors.white, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute(),
          isNotSubscribe: store?.storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.selfDelivery == 0,
        ));
      }
    }

    if(store?.module!.moduleType != 'food') {
      menuList.add(MenuModel(icon: Images.warning, iconColor: Colors.white, title: 'low_stock'.tr, route: RouteHelper.getLowStockRoute()));
    }

    if(modulePermission.reviews!){
      menuList.add(MenuModel(
        icon: Images.review, title: 'reviews'.tr, route: RouteHelper.getCustomerReviewRoute(),
        isNotSubscribe: store?.storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.review == 0,
      ));
    }

    if(modulePermission.businessPlan!){
      menuList.add(MenuModel(icon: Images.mySubscriptionIcon, title: 'my_business_plan'.tr, route: RouteHelper.getMySubscriptionRoute()));
    }

    if(store?.module!.moduleType == 'food' && modulePermission.addon!) {
      menuList.add(MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()));
    }

    if(modulePermission.chat!) {
      menuList.add(
        MenuModel(
          icon: Images.chat, title: 'conversation'.tr, route: RouteHelper.getConversationListRoute(),
          isNotSubscribe: (store?.storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.chat == 0),
        ),
      );
    }

    menuList.add(MenuModel(icon: Images.language, title: 'language'.tr, route: '', isLanguage: true));

    if(modulePermission.coupon!) {
      menuList.add(MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute()));
    }

    if(modulePermission.expenseReport! || modulePermission.vatReport!) {
      menuList.add(MenuModel(icon: Images.expense, title: 'reports'.tr, route: RouteHelper.getReportsRoute()));
    }

    if(modulePermission.disbursementReport! || modulePermission.walletMethod!){
      if(Get.find<SplashController>().configModel!.disbursementType == 'automated') {
        menuList.add(MenuModel(icon: Images.disbursementIcon, title: 'disbursement'.tr, route: RouteHelper.getDisbursementMenuRoute()));
      }
    }
    menuList.add(MenuModel(icon: Images.settingIcon, title: 'settings'.tr, route: RouteHelper.getSettingRoute()));

    menuList.add(MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()));
    menuList.add(MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()));
    menuList.add(MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculer le nombre de lignes nécessaires
        int crossAxisCount = 4;
        int rowCount = (menuList.length / crossAxisCount).ceil();
        
        // Calculer la largeur disponible pour le GridView
        double availableWidth = constraints.maxWidth - (Dimensions.paddingSizeDefault * 2);
        double cellWidth = (availableWidth - (Dimensions.paddingSizeExtraSmall * (crossAxisCount - 1))) / crossAxisCount;
        
        // Calculer la hauteur réelle nécessaire pour chaque cellule basée sur MenuButtonWidget
        // Dans MenuButtonWidget: size = (context.width/4)-Dimensions.paddingSizeDefault
        // Mais ici cellWidth est déjà calculé différemment, donc on utilise directement cellWidth
        double buttonSize = cellWidth; // Taille de base du bouton
        double iconContainerHeight = buttonSize - (buttonSize * 0.2); // height: size-(size*0.2)
        double iconPadding = Dimensions.paddingSizeDefault * 2; // padding all autour de l'icon
        double iconMargin = Dimensions.paddingSizeSmall * 2; // margin horizontal du Container
        double textSpacing = Dimensions.paddingSizeExtraSmall; // SizedBox entre icon et text
        double textHeight = (Dimensions.fontSizeSmall * 1.5) * 2; // 2 lignes max avec line height 1.5
        double totalCellHeight = iconContainerHeight + iconPadding + iconMargin + textSpacing + textHeight;
        
        // Utiliser un childAspectRatio qui laisse assez d'espace pour éviter les débordements
        double childAspectRatio = cellWidth / totalCellHeight;
        
        // Calculer la hauteur totale du GridView avec une marge de sécurité pour éviter les 0.405 pixels
        double gridViewHeight = (totalCellHeight * rowCount) + (Dimensions.paddingSizeExtraSmall * (rowCount - 1)) + 3.0;
        
        // Hauteur totale du contenu
        double headerHeight = 30 + Dimensions.paddingSizeExtraSmall; // Icon + SizedBox
        double bottomPadding = Dimensions.paddingSizeSmall;
        double totalHeight = headerHeight + gridViewHeight + bottomPadding;
        
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
            color: Theme.of(context).cardColor,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight == double.infinity ? totalHeight : 0,
              ),
              child: IntrinsicHeight(
                child: Column(mainAxisSize: MainAxisSize.min, children: [

                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  SizedBox(
                    height: gridViewHeight,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
                        mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                      ),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        return MenuButtonWidget(menu: menuList[index], isProfile: index == 0, isLogout: index == menuList.length-1);
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
