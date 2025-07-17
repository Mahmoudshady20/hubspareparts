import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @safeCart.
  ///
  /// In en, this message translates to:
  /// **'HubSpareParts'**
  String get safeCart;

  /// No description provided for @please_select_a_country.
  ///
  /// In en, this message translates to:
  /// **'Please select a country'**
  String get please_select_a_country;

  /// No description provided for @please_select_a_state.
  ///
  /// In en, this message translates to:
  /// **'Please select a state'**
  String get please_select_a_state;

  /// No description provided for @profile_info_successfully_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile info successfully updated'**
  String get profile_info_successfully_updated;

  /// No description provided for @profile_info_updated_failed.
  ///
  /// In en, this message translates to:
  /// **'Profile info updated failed'**
  String get profile_info_updated_failed;

  /// No description provided for @city_Town.
  ///
  /// In en, this message translates to:
  /// **'City/Town'**
  String get city_Town;

  /// No description provided for @enter_your_city_town.
  ///
  /// In en, this message translates to:
  /// **'Enter your city/town'**
  String get enter_your_city_town;

  /// No description provided for @enter_a_valid_city_town.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid city/town'**
  String get enter_a_valid_city_town;

  /// No description provided for @enter_a_valid_address.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid address'**
  String get enter_a_valid_address;

  /// No description provided for @address_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully.'**
  String get address_added_successfully;

  /// No description provided for @failed_to_add_Address.
  ///
  /// In en, this message translates to:
  /// **'Failed to add Address.'**
  String get failed_to_add_Address;

  /// No description provided for @enter_city_town.
  ///
  /// In en, this message translates to:
  /// **'Enter city/town'**
  String get enter_city_town;

  /// No description provided for @welcome_to.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome_to;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @please_turn_on_your_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'Please turn on your internet connection'**
  String get please_turn_on_your_internet_connection;

  /// No description provided for @your_payment_process_will_get_terminated.
  ///
  /// In en, this message translates to:
  /// **'Your payment process will get terminated'**
  String get your_payment_process_will_get_terminated;

  /// No description provided for @login_to_checkout.
  ///
  /// In en, this message translates to:
  /// **'Login to checkout?'**
  String get login_to_checkout;

  /// No description provided for @you_have_to_login_to_proceed_the_checkout.
  ///
  /// In en, this message translates to:
  /// **'You have to  login to proceed the checkout.'**
  String get you_have_to_login_to_proceed_the_checkout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// No description provided for @search_your_need_here.
  ///
  /// In en, this message translates to:
  /// **'Search your need here'**
  String get search_your_need_here;

  /// No description provided for @press_again_to_exit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit'**
  String get press_again_to_exit;

  /// No description provided for @find_Your_Style.
  ///
  /// In en, this message translates to:
  /// **'Find Your Category'**
  String get find_Your_Style;

  /// No description provided for @find_Your_Brand.
  ///
  /// In en, this message translates to:
  /// **'Find Your Brand'**
  String get find_Your_Brand;

  /// No description provided for @featured_Item.
  ///
  /// In en, this message translates to:
  /// **'Featured Item'**
  String get featured_Item;

  /// No description provided for @hot_Items.
  ///
  /// In en, this message translates to:
  /// **'Hot Items'**
  String get hot_Items;

  /// No description provided for @you_ll_have_to_Sign_in_Sign_up_to_edit_or_see_your_profile_info.
  ///
  /// In en, this message translates to:
  /// **'You\'ll have to Sign-in/Sign-up to edit or see your profile info.'**
  String get you_ll_have_to_Sign_in_Sign_up_to_edit_or_see_your_profile_info;

  /// No description provided for @status_Change_successful.
  ///
  /// In en, this message translates to:
  /// **'Status Change successful'**
  String get status_Change_successful;

  /// No description provided for @status_Change_failed.
  ///
  /// In en, this message translates to:
  /// **'Status Change failed'**
  String get status_Change_failed;

  /// No description provided for @priority_Change_failed.
  ///
  /// In en, this message translates to:
  /// **'Priority Change failed'**
  String get priority_Change_failed;

  /// No description provided for @message_sent.
  ///
  /// In en, this message translates to:
  /// **'Message sent.'**
  String get message_sent;

  /// No description provided for @enter_a_valid_card.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card'**
  String get enter_a_valid_card;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @expiry_date.
  ///
  /// In en, this message translates to:
  /// **'Expiry-date'**
  String get expiry_date;

  /// No description provided for @select_expiry_date.
  ///
  /// In en, this message translates to:
  /// **'Select expiry-date'**
  String get select_expiry_date;

  /// No description provided for @card_code.
  ///
  /// In en, this message translates to:
  /// **'Card code'**
  String get card_code;

  /// No description provided for @enter_a_valid_card_code.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card code'**
  String get enter_a_valid_card_code;

  /// No description provided for @no_states_found.
  ///
  /// In en, this message translates to:
  /// **'No states found'**
  String get no_states_found;

  /// No description provided for @enter_a_valid_coupon.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid coupon'**
  String get enter_a_valid_coupon;

  /// No description provided for @sign_up_succeeded.
  ///
  /// In en, this message translates to:
  /// **'Sign up succeeded'**
  String get sign_up_succeeded;

  /// No description provided for @invalid_email_or_Password.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or Password'**
  String get invalid_email_or_Password;

  /// No description provided for @priority_Change_successful.
  ///
  /// In en, this message translates to:
  /// **'Priority Change successful'**
  String get priority_Change_successful;

  /// No description provided for @sign_In.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_In;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get request_timeout;

  /// No description provided for @oTP_send_error.
  ///
  /// In en, this message translates to:
  /// **'OTP send error'**
  String get oTP_send_error;

  /// No description provided for @password_reset_successful.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get password_reset_successful;

  /// No description provided for @password_reset_failed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get password_reset_failed;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get something_went_wrong;

  /// No description provided for @sign_in_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get sign_in_failed;

  /// No description provided for @account_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Account delete failed'**
  String get account_delete_failed;

  /// No description provided for @please_enter_all_the_shipping_info.
  ///
  /// In en, this message translates to:
  /// **'Please enter all the shipping info'**
  String get please_enter_all_the_shipping_info;

  /// No description provided for @this_account_has_been_deleted.
  ///
  /// In en, this message translates to:
  /// **'This account has been deleted!'**
  String get this_account_has_been_deleted;

  /// No description provided for @sign_up_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get sign_up_failed;

  /// No description provided for @registration_succeeded.
  ///
  /// In en, this message translates to:
  /// **'Registration succeeded!'**
  String get registration_succeeded;

  /// No description provided for @select_an_image_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Select an image from gallery'**
  String get select_an_image_from_gallery;

  /// No description provided for @take_an_image_to_proceed.
  ///
  /// In en, this message translates to:
  /// **'Take an image to proceed'**
  String get take_an_image_to_proceed;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @loading_failed.
  ///
  /// In en, this message translates to:
  /// **'Loading failed!'**
  String get loading_failed;

  /// No description provided for @failed_to_load_payment_page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payment page.'**
  String get failed_to_load_payment_page;

  /// No description provided for @address_delete_successful.
  ///
  /// In en, this message translates to:
  /// **'Address delete successful.'**
  String get address_delete_successful;

  /// No description provided for @address_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Address delete failed.'**
  String get address_delete_failed;

  /// No description provided for @return_button.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get return_button;

  /// No description provided for @invalid_developer_keys.
  ///
  /// In en, this message translates to:
  /// **'Invalid developer keys'**
  String get invalid_developer_keys;

  /// No description provided for @connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connection_failed;

  /// No description provided for @payment_has_been_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment has been failed.'**
  String get payment_has_been_failed;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment has been failed.'**
  String get payment_failed;

  /// No description provided for @item_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Item added to cart'**
  String get item_added_to_cart;

  /// No description provided for @item_subtracted_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Item subtracted from cart'**
  String get item_subtracted_from_cart;

  /// No description provided for @item_added_to_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Item added to wishlist'**
  String get item_added_to_wishlist;

  /// No description provided for @item_removed_from_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Item removed from wishlist'**
  String get item_removed_from_wishlist;

  /// No description provided for @add_new_address.
  ///
  /// In en, this message translates to:
  /// **'Add new address'**
  String get add_new_address;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @enter_a_title.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get enter_a_title;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_an_email.
  ///
  /// In en, this message translates to:
  /// **'Enter an email'**
  String get enter_an_email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @enter_a_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get enter_a_phone_number;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get select_country;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @select_state.
  ///
  /// In en, this message translates to:
  /// **'Select state'**
  String get select_state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enter_city.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enter_city;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @enter_zipcode.
  ///
  /// In en, this message translates to:
  /// **'Enter zipcode'**
  String get enter_zipcode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enter_address;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get add_address;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @no_item_found.
  ///
  /// In en, this message translates to:
  /// **'No item found'**
  String get no_item_found;

  /// No description provided for @my_Cart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get my_Cart;

  /// No description provided for @clear_cart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clear_cart;

  /// No description provided for @add_item_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add item to cart!'**
  String get add_item_to_cart;

  /// No description provided for @process_to_checkout.
  ///
  /// In en, this message translates to:
  /// **'Process to checkout'**
  String get process_to_checkout;

  /// No description provided for @these_Items_will_be_Deleted.
  ///
  /// In en, this message translates to:
  /// **'These Items will be Deleted.'**
  String get these_Items_will_be_Deleted;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @enter_your_current_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enter_your_current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get current_password;

  /// No description provided for @enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enter_new_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirm_new_password;

  /// No description provided for @re_enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get re_enter_new_password;

  /// No description provided for @change_Password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_Password;

  /// No description provided for @write_message.
  ///
  /// In en, this message translates to:
  /// **'Write message'**
  String get write_message;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @choose_file.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get choose_file;

  /// No description provided for @no_file_chosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get no_file_chosen;

  /// No description provided for @notify_via_mail.
  ///
  /// In en, this message translates to:
  /// **'Notify via mail'**
  String get notify_via_mail;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @no_Message_has_been_found.
  ///
  /// In en, this message translates to:
  /// **'No Message has been found!'**
  String get no_Message_has_been_found;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @saved_Addresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get saved_Addresses;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @order_summery.
  ///
  /// In en, this message translates to:
  /// **'Order summery'**
  String get order_summery;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @coupon_discount.
  ///
  /// In en, this message translates to:
  /// **'Coupon_discount'**
  String get coupon_discount;

  /// No description provided for @shipping_cost.
  ///
  /// In en, this message translates to:
  /// **'Shipping cost'**
  String get shipping_cost;

  /// No description provided for @chose_a_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Choose a payment method'**
  String get chose_a_payment_method;

  /// No description provided for @an_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An_error_occurred'**
  String get an_error_occurred;

  /// No description provided for @zito_pay_username.
  ///
  /// In en, this message translates to:
  /// **'Zito-pay username'**
  String get zito_pay_username;

  /// No description provided for @by_creating_an_account_you_agree_to_the.
  ///
  /// In en, this message translates to:
  /// **'By creating an account,you agree to the'**
  String get by_creating_an_account_you_agree_to_the;

  /// No description provided for @i_Have_Read_And_Agree_To_The_Website.
  ///
  /// In en, this message translates to:
  /// **'I Have Read And Agree To The Website'**
  String get i_Have_Read_And_Agree_To_The_Website;

  /// No description provided for @terms_of_service_and_Conditions.
  ///
  /// In en, this message translates to:
  /// **'terms of service and Conditions'**
  String get terms_of_service_and_Conditions;

  /// No description provided for @terms_and_Conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_Conditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacy_Policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_Policy;

  /// No description provided for @confirm_order.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirm_order;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enter_your_name;

  /// No description provided for @enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_your_email;

  /// No description provided for @enter_your_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get enter_your_phone;

  /// No description provided for @enter_your_city.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enter_your_city;

  /// No description provided for @enter_your_zipcode.
  ///
  /// In en, this message translates to:
  /// **'Enter your zipcode'**
  String get enter_your_zipcode;

  /// No description provided for @enter_your_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enter_your_address;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @verification_Code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_Code;

  /// No description provided for @enter_your_verification_Code.
  ///
  /// In en, this message translates to:
  /// **'Enter your verification Code'**
  String get enter_your_verification_Code;

  /// No description provided for @didn_t_received.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t received?'**
  String get didn_t_received;

  /// No description provided for @send_again.
  ///
  /// In en, this message translates to:
  /// **'Send again.'**
  String get send_again;

  /// No description provided for @wrong_OTP_Code.
  ///
  /// In en, this message translates to:
  /// **'Wrong OTP Code'**
  String get wrong_OTP_Code;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @feature_Items.
  ///
  /// In en, this message translates to:
  /// **'Feature Items'**
  String get feature_Items;

  /// No description provided for @no_more_product_found.
  ///
  /// In en, this message translates to:
  /// **'No more product found'**
  String get no_more_product_found;

  /// No description provided for @campaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaigns;

  /// No description provided for @reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get reset_your_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password;

  /// No description provided for @please_give_all_the_information_properly.
  ///
  /// In en, this message translates to:
  /// **'Please give all the information properly'**
  String get please_give_all_the_information_properly;

  /// No description provided for @couldn_t_add_Ticket.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add Ticket'**
  String get couldn_t_add_Ticket;

  /// No description provided for @add_new_ticket.
  ///
  /// In en, this message translates to:
  /// **'Add new ticket'**
  String get add_new_ticket;

  /// No description provided for @enter_a_valid_title.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid title'**
  String get enter_a_valid_title;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @enter_a_subject.
  ///
  /// In en, this message translates to:
  /// **'Enter a subject'**
  String get enter_a_subject;

  /// No description provided for @enter_a_valid_subject.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid subject'**
  String get enter_a_valid_subject;

  /// No description provided for @enter_a_subject_with_more_then_character.
  ///
  /// In en, this message translates to:
  /// **'Enter a subject with more then 5 character'**
  String get enter_a_subject_with_more_then_character;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describe_your_issue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue'**
  String get describe_your_issue;

  /// No description provided for @you_have_to_give_some_description.
  ///
  /// In en, this message translates to:
  /// **'You have to give some description'**
  String get you_have_to_give_some_description;

  /// No description provided for @add_Ticket.
  ///
  /// In en, this message translates to:
  /// **'Add Ticket'**
  String get add_Ticket;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @order_ID.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_ID;

  /// No description provided for @shipping_Method.
  ///
  /// In en, this message translates to:
  /// **'Shipping Method'**
  String get shipping_Method;

  /// No description provided for @free_Shipping.
  ///
  /// In en, this message translates to:
  /// **'Free Shipping'**
  String get free_Shipping;

  /// No description provided for @payment_Method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_Method;

  /// No description provided for @payment_Status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_Status;

  /// No description provided for @order_Status.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_Status;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get my_orders;

  /// No description provided for @failed_to_load_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data.'**
  String get failed_to_load_data;

  /// No description provided for @no_order_found.
  ///
  /// In en, this message translates to:
  /// **'No order found.'**
  String get no_order_found;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get oops;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get payment_successful;

  /// No description provided for @we_re_getting_problems_with_your_payment_methods_and_we_couldn_t_proceed_your_order.
  ///
  /// In en, this message translates to:
  /// **'We\'re getting problems with your payment methods and we couldn\'t proceed your order.'**
  String get we_re_getting_problems_with_your_payment_methods_and_we_couldn_t_proceed_your_order;

  /// No description provided for @your_order_has_been_successful_You_ll_receive_ordered_items_in_days_Your_order_ID_is.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successful! You\'ll receive ordered items in 3-5 days. Your order ID is '**
  String get your_order_has_been_successful_You_ll_receive_ordered_items_in_days_Your_order_ID_is;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get back_to_home;

  /// No description provided for @track_your_order.
  ///
  /// In en, this message translates to:
  /// **'Track your order'**
  String get track_your_order;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get show_less;

  /// No description provided for @sub_Category.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get sub_Category;

  /// No description provided for @child_Category.
  ///
  /// In en, this message translates to:
  /// **'Child Category'**
  String get child_Category;

  /// No description provided for @sKU.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sKU;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @seller_s_Products.
  ///
  /// In en, this message translates to:
  /// **'Seller\'s Products'**
  String get seller_s_Products;

  /// No description provided for @related_Products.
  ///
  /// In en, this message translates to:
  /// **'Related Products'**
  String get related_Products;

  /// No description provided for @shipping_address.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get shipping_address;

  /// No description provided for @support_Ticket.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get support_Ticket;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get edit_profile;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @sign_in_Sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign in/Sign up'**
  String get sign_in_Sign_up;

  /// No description provided for @enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_your_password;

  /// No description provided for @enter_a_valid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enter_a_valid_email_address;

  /// No description provided for @send_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get send_verification_code;

  /// No description provided for @no_address_found.
  ///
  /// In en, this message translates to:
  /// **'No address found!'**
  String get no_address_found;

  /// No description provided for @add_new_Address.
  ///
  /// In en, this message translates to:
  /// **'Add new Address'**
  String get add_new_Address;

  /// No description provided for @welcome_Back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_Back;

  /// No description provided for @email_Username.
  ///
  /// In en, this message translates to:
  /// **'Email/Username'**
  String get email_Username;

  /// No description provided for @enter_your_email_or_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or username'**
  String get enter_your_email_or_username;

  /// No description provided for @enter_your_Password.
  ///
  /// In en, this message translates to:
  /// **'Enter your Password'**
  String get enter_your_Password;

  /// No description provided for @password_must_be_more_then_character.
  ///
  /// In en, this message translates to:
  /// **'Password must be more then 6 character'**
  String get password_must_be_more_then_character;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @don_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get don_have_an_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @sign_in_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get sign_in_with_Google;

  /// No description provided for @sign_in_with_Facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get sign_in_with_Facebook;

  /// No description provided for @you_have_to_select_a_country.
  ///
  /// In en, this message translates to:
  /// **'You have to select a country'**
  String get you_have_to_select_a_country;

  /// No description provided for @you_have_to_select_a_state.
  ///
  /// In en, this message translates to:
  /// **'You have to select a state'**
  String get you_have_to_select_a_state;

  /// No description provided for @you_have_to_agree_our_terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'You have to agree our terms and conditions'**
  String get you_have_to_agree_our_terms_and_conditions;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @enter_a_valid_name.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enter_a_valid_name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enter_your_username;

  /// No description provided for @enter_a_valid_username.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid username'**
  String get enter_a_valid_username;

  /// No description provided for @select_your_Country.
  ///
  /// In en, this message translates to:
  /// **'Select your Country'**
  String get select_your_Country;

  /// No description provided for @select_your_State.
  ///
  /// In en, this message translates to:
  /// **'Select your State'**
  String get select_your_State;

  /// No description provided for @enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_your_phone_number;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @re_enter_your_Password.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your Password'**
  String get re_enter_your_Password;

  /// No description provided for @password_didn_match.
  ///
  /// In en, this message translates to:
  /// **'Password didn\'t match'**
  String get password_didn_match;

  /// No description provided for @please_provide_current_password.
  ///
  /// In en, this message translates to:
  /// **'Please provide current password'**
  String get please_provide_current_password;

  /// No description provided for @sign_Up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_Up;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @sign_up_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get sign_up_with_Google;

  /// No description provided for @sign_up_with_Facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get sign_up_with_Facebook;

  /// No description provided for @my_Tickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get my_Tickets;

  /// No description provided for @no_ticket_found.
  ///
  /// In en, this message translates to:
  /// **'No ticket found'**
  String get no_ticket_found;

  /// No description provided for @no_data_has_been_found.
  ///
  /// In en, this message translates to:
  /// **'No data has been found'**
  String get no_data_has_been_found;

  /// No description provided for @items_removed_from_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Items removed from wishlist'**
  String get items_removed_from_wishlist;

  /// No description provided for @clear_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Clear wishlist'**
  String get clear_wishlist;

  /// No description provided for @add_items_to_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Add items to wishlist'**
  String get add_items_to_wishlist;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @item_removed_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Item removed from cart'**
  String get item_removed_from_cart;

  /// No description provided for @this_Item_will_be_Deleted.
  ///
  /// In en, this message translates to:
  /// **'This Item will be Deleted.'**
  String get this_Item_will_be_Deleted;

  /// No description provided for @coupon_Text.
  ///
  /// In en, this message translates to:
  /// **'Coupon Text'**
  String get coupon_Text;

  /// No description provided for @apply_shipping.
  ///
  /// In en, this message translates to:
  /// **'Apply shipping'**
  String get apply_shipping;

  /// No description provided for @shipping_information.
  ///
  /// In en, this message translates to:
  /// **'Shipping information'**
  String get shipping_information;

  /// No description provided for @town_City.
  ///
  /// In en, this message translates to:
  /// **'Town/City'**
  String get town_City;

  /// No description provided for @enter_Town_city_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Town/City name'**
  String get enter_Town_city_name;

  /// No description provided for @enter_an_address.
  ///
  /// In en, this message translates to:
  /// **'Enter an address'**
  String get enter_an_address;

  /// No description provided for @order_note.
  ///
  /// In en, this message translates to:
  /// **'Order note'**
  String get order_note;

  /// No description provided for @enter_Order_note.
  ///
  /// In en, this message translates to:
  /// **'Enter Order note'**
  String get enter_Order_note;

  /// No description provided for @select_a_shipping_method.
  ///
  /// In en, this message translates to:
  /// **'Select a shipping method'**
  String get select_a_shipping_method;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @see_All.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_All;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @campaign_Products.
  ///
  /// In en, this message translates to:
  /// **'Campaign Products'**
  String get campaign_Products;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @order_Summery.
  ///
  /// In en, this message translates to:
  /// **'Order Summery'**
  String get order_Summery;

  /// No description provided for @order_status.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get order_status;

  /// No description provided for @this_order_will_be_canceled.
  ///
  /// In en, this message translates to:
  /// **'This order will be canceled'**
  String get this_order_will_be_canceled;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get add_to_cart;

  /// No description provided for @sold_count.
  ///
  /// In en, this message translates to:
  /// **'Sold count'**
  String get sold_count;

  /// No description provided for @your_rating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get your_rating;

  /// No description provided for @your_review.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get your_review;

  /// No description provided for @write_your_feedback.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback'**
  String get write_your_feedback;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @order_Completion_Rate.
  ///
  /// In en, this message translates to:
  /// **'Order Completion Rate'**
  String get order_Completion_Rate;

  /// No description provided for @about_Since.
  ///
  /// In en, this message translates to:
  /// **'About Since'**
  String get about_Since;

  /// No description provided for @satisfied_Client.
  ///
  /// In en, this message translates to:
  /// **'Satisfied Client'**
  String get satisfied_Client;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @current_rating.
  ///
  /// In en, this message translates to:
  /// **'Current Ratings'**
  String get current_rating;

  /// No description provided for @voltage_rating.
  ///
  /// In en, this message translates to:
  /// **'Voltage Rating'**
  String get voltage_rating;

  /// No description provided for @control_voltage.
  ///
  /// In en, this message translates to:
  /// **'Control Voltage'**
  String get control_voltage;

  /// No description provided for @power_rating.
  ///
  /// In en, this message translates to:
  /// **'Power Rating'**
  String get power_rating;

  /// No description provided for @filter_Price.
  ///
  /// In en, this message translates to:
  /// **'Filter Price'**
  String get filter_Price;

  /// No description provided for @average_Rating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get average_Rating;

  /// No description provided for @reset_Filter.
  ///
  /// In en, this message translates to:
  /// **'Reset Filter'**
  String get reset_Filter;

  /// No description provided for @apply_Filter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get apply_Filter;

  /// No description provided for @this_address_will_be_deleted_permanently.
  ///
  /// In en, this message translates to:
  /// **'This address will be deleted permanently'**
  String get this_address_will_be_deleted_permanently;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @select_attributes.
  ///
  /// In en, this message translates to:
  /// **'Select attributes'**
  String get select_attributes;

  /// No description provided for @select_all_attribute_to_proceed.
  ///
  /// In en, this message translates to:
  /// **'Select all attributes to proceed'**
  String get select_all_attribute_to_proceed;

  /// No description provided for @please_select_an_attribute_set.
  ///
  /// In en, this message translates to:
  /// **'Please select an attribute set'**
  String get please_select_an_attribute_set;

  /// No description provided for @items_total.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get items_total;

  /// No description provided for @you_have_agree_to_our_Terms_Conditions.
  ///
  /// In en, this message translates to:
  /// **'You have agree to our Terms & Conditions'**
  String get you_have_agree_to_our_Terms_Conditions;

  /// No description provided for @safeCart_Products.
  ///
  /// In en, this message translates to:
  /// **'HubSpareParts Products'**
  String get safeCart_Products;

  /// No description provided for @payment_confirm_success.
  ///
  /// In en, this message translates to:
  /// **'Payment confirm success'**
  String get payment_confirm_success;

  /// No description provided for @payment_confirm_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirm failed'**
  String get payment_confirm_failed;

  /// No description provided for @please_enter_all_the_information.
  ///
  /// In en, this message translates to:
  /// **'Please enter all the information'**
  String get please_enter_all_the_information;

  /// No description provided for @sign_out_successful.
  ///
  /// In en, this message translates to:
  /// **'Sign out successful'**
  String get sign_out_successful;

  /// No description provided for @password_change_failed.
  ///
  /// In en, this message translates to:
  /// **'Password change failed'**
  String get password_change_failed;

  /// No description provided for @password_change_succeeded.
  ///
  /// In en, this message translates to:
  /// **'Password change succeeded'**
  String get password_change_succeeded;

  /// No description provided for @review_submitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted'**
  String get review_submitted;

  /// No description provided for @review_submission_failed.
  ///
  /// In en, this message translates to:
  /// **'Review submission failed'**
  String get review_submission_failed;

  /// No description provided for @attribute_set_selected.
  ///
  /// In en, this message translates to:
  /// **'Attribute set selected'**
  String get attribute_set_selected;

  /// No description provided for @order_placing_failed.
  ///
  /// In en, this message translates to:
  /// **'Order placing failed'**
  String get order_placing_failed;

  /// No description provided for @oTP_verification_failed.
  ///
  /// In en, this message translates to:
  /// **'OTP verification failed!'**
  String get oTP_verification_failed;

  /// No description provided for @uploading_image_this_might_take_some_time.
  ///
  /// In en, this message translates to:
  /// **'Uploading image, this might take some time'**
  String get uploading_image_this_might_take_some_time;

  /// No description provided for @your_order_has_been_successful_You_ll_receive_ordered_items_in_days.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successful! You\'ll receive ordered items in 3-5 days'**
  String get your_order_has_been_successful_You_ll_receive_ordered_items_in_days;

  /// No description provided for @order_submitted.
  ///
  /// In en, this message translates to:
  /// **'Order submitted'**
  String get order_submitted;

  /// No description provided for @your_order_ID_is.
  ///
  /// In en, this message translates to:
  /// **'Your order ID is'**
  String get your_order_ID_is;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @no_more_order_found.
  ///
  /// In en, this message translates to:
  /// **'No more order found'**
  String get no_more_order_found;

  /// No description provided for @no_more_ticket_found.
  ///
  /// In en, this message translates to:
  /// **'No more ticket found'**
  String get no_more_ticket_found;

  /// No description provided for @no_more_shipping_address_found.
  ///
  /// In en, this message translates to:
  /// **'No more shipping address found'**
  String get no_more_shipping_address_found;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @no_wifi_or_cellular_data_found.
  ///
  /// In en, this message translates to:
  /// **'No wifi or cellular data found'**
  String get no_wifi_or_cellular_data_found;

  /// No description provided for @invalid_url.
  ///
  /// In en, this message translates to:
  /// **'Invalid url'**
  String get invalid_url;

  /// No description provided for @search_State.
  ///
  /// In en, this message translates to:
  /// **'Search State'**
  String get search_State;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @search_country.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get search_country;

  /// No description provided for @search_city.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get search_city;

  /// No description provided for @no_result_found.
  ///
  /// In en, this message translates to:
  /// **'No result found'**
  String get no_result_found;

  /// No description provided for @product_stock_is_insufficient.
  ///
  /// In en, this message translates to:
  /// **'Product stock is insufficient'**
  String get product_stock_is_insufficient;

  /// No description provided for @ship_to_a_different_location.
  ///
  /// In en, this message translates to:
  /// **'Ship to a different location?'**
  String get ship_to_a_different_location;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @apple_original_chair_collection.
  ///
  /// In en, this message translates to:
  /// **'Apple Original Chair Collection'**
  String get apple_original_chair_collection;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get order_details;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @order_has_been_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Order has been cancelled'**
  String get order_has_been_cancelled;

  /// No description provided for @order_has_been_delivered.
  ///
  /// In en, this message translates to:
  /// **'Order has been delivered'**
  String get order_has_been_delivered;

  /// No description provided for @shipping_details.
  ///
  /// In en, this message translates to:
  /// **'Shipping details'**
  String get shipping_details;

  /// No description provided for @street_address.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get street_address;

  /// No description provided for @show_all.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get show_all;

  /// No description provided for @no_information_available.
  ///
  /// In en, this message translates to:
  /// **'No information available'**
  String get no_information_available;

  /// No description provided for @no_sub_category_available.
  ///
  /// In en, this message translates to:
  /// **'No sub category available'**
  String get no_sub_category_available;

  /// No description provided for @child_category.
  ///
  /// In en, this message translates to:
  /// **'Child category'**
  String get child_category;

  /// No description provided for @could_not_load_any_message.
  ///
  /// In en, this message translates to:
  /// **'Could not load any message'**
  String get could_not_load_any_message;

  /// No description provided for @no_more_message_found.
  ///
  /// In en, this message translates to:
  /// **'No more message found'**
  String get no_more_message_found;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @my_wishlist.
  ///
  /// In en, this message translates to:
  /// **'My wishlist'**
  String get my_wishlist;

  /// No description provided for @sub_order_id.
  ///
  /// In en, this message translates to:
  /// **'Sub-order Id'**
  String get sub_order_id;

  /// No description provided for @transaction_id.
  ///
  /// In en, this message translates to:
  /// **'Transaction Id'**
  String get transaction_id;

  /// No description provided for @payment_getaway.
  ///
  /// In en, this message translates to:
  /// **'Payment Getaway'**
  String get payment_getaway;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @select_city.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get select_city;

  /// No description provided for @your_order_has_been_placed.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed, but there was an issue with your payment. Your order ID is '**
  String get your_order_has_been_placed;

  /// No description provided for @account_delete_successful.
  ///
  /// In en, this message translates to:
  /// **'Account delete successful'**
  String get account_delete_successful;

  /// No description provided for @complete_Your_Purchase.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Purchase'**
  String get complete_Your_Purchase;

  /// No description provided for @please_provide_payment_document.
  ///
  /// In en, this message translates to:
  /// **'Please provide payment document'**
  String get please_provide_payment_document;

  /// No description provided for @server_connection_slow.
  ///
  /// In en, this message translates to:
  /// **'Server connection slow'**
  String get server_connection_slow;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @my_points.
  ///
  /// In en, this message translates to:
  /// **'My Points : '**
  String get my_points;

  String get refund_status;

  String get my_refund;

  String get refund_requests;

  String get no_refund_found;

  String get no_more_refund_found;

  String get number_of_products;

  String get refund;

  String get refund_info;

  String get items;

  String get status_history;

  String get request_refund;

  String get refund_reason;

  String get refund_preferred_options;

  String get additional_information;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
