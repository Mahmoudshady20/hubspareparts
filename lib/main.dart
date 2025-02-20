import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/settings_helper.dart';
import 'package:safecart/services/internet_checker_service.dart';
import 'package:safecart/services/location/city_dropdown_service.dart';
import 'package:safecart/services/location/country_dropdown_service.dart';
import 'package:safecart/services/location/state_dropdown_service.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/common_helper.dart';
import '../helpers/intro_helper.dart';
import '../helpers/navigation_helper.dart';
import '../services/app_strings_service.dart';
import '../services/auth_service/account_delete_service.dart';
import '../services/auth_service/change_password_service.dart';
import '../services/auth_service/otp_service.dart';
import '../services/auth_service/reset_password_service.dart';
import '../services/auth_service/save_sign_in_info_service.dart';
import '../services/auth_service/sign_in_service.dart';
import '../services/auth_service/sign_out_service.dart';
import '../services/auth_service/sign_up_service.dart';
import '../services/auth_service/social_signin_signup_service.dart';
import '../services/cart_data_service.dart';
import '../services/category_service.dart';
import '../services/chat_service.dart';
import '../services/checkout_service/calculate_tax_service.dart';
import '../services/checkout_service/checkout_service.dart';
import '../services/checkout_service/shipping_address_service.dart';
import '../services/common_services.dart';
import '../services/feature_products_service.dart';
import '../services/filters_service.dart';
import '../services/home_campaign_products_service.dart';
import '../services/home_campaigns_service.dart';
import '../services/home_categories_service.dart';
import '../services/home_service/slider_one_service.dart';
import '../services/intro_service.dart';
import '../services/new_ticket_service.dart';
import '../services/orders_service/order_details_service.dart';
import '../services/orders_service/order_list_service.dart';
import '../services/payment_gateway_service.dart';
import '../services/product_by_campaigns_service.dart';
import '../services/product_details_service.dart';
import '../services/profile_info_service.dart';
import '../services/push_notification_service.dart';
import '../services/rtl_service.dart';
import '../services/search_seatvice.dart';
import '../services/slider_service.dart';
import '../services/terms_and_condition_service.dart';
import '../services/ticket_chat_service.dart';
import '../services/ticket_list_service.dart';
import '../services/wishlist_data_service.dart';
import '../themes/default_themes.dart';
import '../views/all_categories_view.dart';
import '../views/change_password_view.dart';
import '../views/checkout_view.dart';
import '../views/edit_profile_view.dart';
import '../views/feature_products_view.dart';
import '../views/home_campaigns_view.dart';
import '../views/home_front_view.dart';
import '../views/intro_view.dart';
import '../views/new_ticket_view.dart';
import '../views/orders_list_view.dart';
import '../views/product_by_campaign_view.dart';
import '../views/product_by_category_view.dart';
import '../views/product_search_view.dart';
import '../views/shipping_address_list_view.dart';
import '../views/sign_in_view.dart';
import '../views/splash_view.dart';
import '../views/ticket_list_view.dart';
import 'services/all_product_service.dart';
import 'services/search_filter_data_service.dart';
import 'services/search_product_service.dart';
import 'services/submit_review_service.dart';
import 'views/product_details_view.dart';
import 'widgets/common/web_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.dark,
  ));
  ErrorWidget.builder = (details) {
    bool debugMode = false;
    assert(() {
      debugMode = true;
      return true;
    }());
    if (debugMode) {
      return ErrorWidget(details.exception);
    }
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  details.exception.toString(),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'An error ocurred with the app, please contact the developer',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider()..init(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingProvider = Provider.of<SettingsProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStringService>(
            create: (context) => AppStringService()),
        ChangeNotifierProvider<IntroHelper>(create: (context) => IntroHelper()),
        ChangeNotifierProvider<CommonServices>(
            create: (context) => CommonServices()),
        ChangeNotifierProvider<NavigationHelper>(
            create: (context) => NavigationHelper()),
        ChangeNotifierProvider<SearchService>(
            create: (context) => SearchService()),
        ChangeNotifierProvider<CategoryService>(
            create: (context) => CategoryService()),
        ChangeNotifierProvider<RTLService>(create: (context) => RTLService()),
        ChangeNotifierProvider<SliderOneService>(
            create: (context) => SliderOneService()),
        ChangeNotifierProvider<ProductDetailsService>(
            create: (context) => ProductDetailsService()),
        ChangeNotifierProvider<ProfileInfoService>(
            create: (context) => ProfileInfoService()),
        ChangeNotifierProvider<WishlistDataService>(
            create: (context) => WishlistDataService()),
        ChangeNotifierProvider<CartDataService>(
            create: (context) => CartDataService()),
        ChangeNotifierProvider<SearchProductService>(
            create: (context) => SearchProductService()),
        ChangeNotifierProvider<TicketListService>(
            create: (context) => TicketListService()),
        ChangeNotifierProvider<ChatService>(create: (context) => ChatService()),
        ChangeNotifierProvider<CheckoutService>(
            create: (context) => CheckoutService()),
        ChangeNotifierProvider<PaymentGatewayService>(
            create: (context) => PaymentGatewayService()),
        ChangeNotifierProvider<ShippingAddressService>(
            create: (context) => ShippingAddressService()),
        ChangeNotifierProvider<OrderListService>(
            create: (context) => OrderListService()),
        ChangeNotifierProvider<OrderDetailsService>(
            create: (context) => OrderDetailsService()),
        ChangeNotifierProvider<TermsAndCondition>(
            create: (context) => TermsAndCondition()),
        ChangeNotifierProvider<FiltersService>(
            create: (context) => FiltersService()),
        ChangeNotifierProvider<NewTicketService>(
            create: (context) => NewTicketService()),
        ChangeNotifierProvider<ProfileInfoService>(
            create: (context) => ProfileInfoService()),
        ChangeNotifierProvider<CountryDropdownService>(
            create: (context) => CountryDropdownService()),
        ChangeNotifierProvider<CityDropdownService>(
            create: (context) => CityDropdownService()),
        ChangeNotifierProvider<StatesDropdownService>(
            create: (context) => StatesDropdownService()),
        ChangeNotifierProvider<SaveSignInInfoService>(
            create: (context) => SaveSignInInfoService()),
        ChangeNotifierProvider<SignInService>(
            create: (context) => SignInService()),
        ChangeNotifierProvider<SignUpService>(
            create: (context) => SignUpService()),
        ChangeNotifierProvider<OtpService>(create: (context) => OtpService()),
        ChangeNotifierProvider<ResetPasswordService>(
            create: (context) => ResetPasswordService()),
        ChangeNotifierProvider<HomeCategoriesService>(
            create: (context) => HomeCategoriesService()),
        ChangeNotifierProvider<SliderService>(
            create: (context) => SliderService()),
        ChangeNotifierProvider<FeatureProductsService>(
            create: (context) => FeatureProductsService()),
        ChangeNotifierProvider<HomeCampaignsService>(
            create: (context) => HomeCampaignsService()),
        ChangeNotifierProvider<IntroService>(
            create: (context) => IntroService()),
        ChangeNotifierProvider<SearchFilterDataService>(
            create: (context) => SearchFilterDataService()),
        ChangeNotifierProvider<SubmitReviewService>(
            create: (context) => SubmitReviewService()),
        ChangeNotifierProvider<TicketChatService>(
            create: (context) => TicketChatService()),
        ChangeNotifierProvider<CalculateTaxService>(
            create: (context) => CalculateTaxService()),
        ChangeNotifierProvider<SignOutService>(
            create: (context) => SignOutService()),
        ChangeNotifierProvider<AccountDeleteService>(
            create: (context) => AccountDeleteService()),
        ChangeNotifierProvider<ChangePasswordService>(
            create: (context) => ChangePasswordService()),
        ChangeNotifierProvider<PushNotificationService>(
            create: (context) => PushNotificationService()),
        ChangeNotifierProvider<AllProductsService>(
            create: (context) => AllProductsService()),
        ChangeNotifierProvider<InternetCheckerService>(
            create: (context) => InternetCheckerService()),
        ChangeNotifierProvider<ProductByCampaignsService>(
            create: (context) => ProductByCampaignsService()),
        ChangeNotifierProvider<HomeCampaignProductsService>(
            create: (context) => HomeCampaignProductsService()),
        ChangeNotifierProvider<SocialSignInSignUpService>(
            create: (context) => SocialSignInSignUpService()),
      ],
      child: Consumer<RTLService>(builder: (context, rtlProvider, child) {
        return MaterialApp(
          title: 'SafeCart',
          navigatorKey: navigatorKey,
          // builder: (context, rtlchild) {
          //   return Directionality(
          //     textDirection:
          //         rtlProvider.langRtl ? TextDirection.rtl : TextDirection.ltr,
          //     child: rtlchild!,
          //   );
          // },
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: settingProvider.myLocal,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: cc.blackColor),
              bodySmall: TextStyle(color: cc.blackColor),
              titleLarge: TextStyle(color: cc.blackColor, fontSize: 18),
              titleMedium: TextStyle(color: cc.blackColor, fontSize: 16),
              titleSmall: TextStyle(color: cc.blackColor, fontSize: 14),
              bodyMedium: TextStyle(color: cc.blackColor, fontSize: 12),
            ),
            radioTheme: DefaultThemes().radioThemeData(context, cc),
            appBarTheme: DefaultThemes().appBarTheme(context, cc),
            elevatedButtonTheme:
                DefaultThemes().elevatedButtonTheme(context, cc),
            outlinedButtonTheme:
                DefaultThemes().outlinedButtonTheme(context, cc),
            inputDecorationTheme:
                DefaultThemes().inputDecorationTheme(context, cc),
            checkboxTheme: DefaultThemes().checkboxTheme(context, cc),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const SplashView(),
          routes: {
            IntroView.routeName: (context) => IntroView(),
            HomeFrontView.routeName: (context) => HomeFrontView(),
            ProductDetailsView.routeName: (context) => ProductDetailsView(),
            SignInView.routeName: (context) => SignInView(),
            EditProfileView.routeName: (context) => EditProfileView(),
            FeatureProductsView.routeName: (context) => FeatureProductsView(),
            TicketListView.routeName: (context) => TicketListView(),
            AllCategoriesView.routeName: (context) => AllCategoriesView(),
            CheckoutView.routeName: (context) => CheckoutView(),
            OrdersListView.routeName: (context) => OrdersListView(),
            WebViewScreen.routeName: (context) => const WebViewScreen(),
            ProductSearchView.routeName: (context) => ProductSearchView(),
            NewTicketView.routeName: (context) => NewTicketView(),
            HomeCampaignsView.routeName: (context) => HomeCampaignsView(),
            ProductByCampaignView.routeName: (context) =>
                ProductByCampaignView(),
            ShippingAddressListView.routeName: (context) =>
                ShippingAddressListView(),
            ProductByCategoryView.routeName: (context) =>
                ProductByCategoryView(),
            ChangePasswordView.routeName: (context) => ChangePasswordView(),
          },
        );
      }),
    );
  }
}
