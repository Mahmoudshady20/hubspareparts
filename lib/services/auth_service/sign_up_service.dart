import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import '../../models/city_dropdown_model.dart';
import '../../models/country_model.dart';
import '../../models/state_model.dart';
import '../../views/enter_otp_view.dart';

class SignUpService with ChangeNotifier {
  String? selectedCountryName;
  String? selectedStateName;
  bool loadingSignUp = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  bool acceptTPP = false;
  Country? selectedCountry;
  States? selectedState;
  City? selectedCity;

  setLoadingSignUp(value) {
    loadingSignUp = value;
    notifyListeners();
  }

  setObscurePasswordOne(value) {
    obscurePasswordOne = value ?? !obscurePasswordOne;
    notifyListeners();
  }

  setObscurePasswordTwo(value) {
    obscurePasswordTwo = value ?? !obscurePasswordTwo;
    notifyListeners();
  }

  setAcceptTPP(value) {
    acceptTPP = value ?? !acceptTPP;
    notifyListeners();
  }

  setSelectedCountry(value) {
    selectedCountry = value;
    notifyListeners();
  }

  setSelectedState(value) {
    selectedState = value;
    notifyListeners();
  }

  signUp(
    BuildContext context,
    String name,
    String email,
    String username,
    String password,
    String phone,
  ) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    setLoadingSignUp(true);
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/register'));
      request.fields.addAll({
        'username': username,
        'password': password,
        'full_name': name,
        'email': email,
        'phone': phone,
        'state_id': selectedState?.id.toString() ?? '',
        'city': selectedCity?.id.toString() ?? "",
        'country_id': selectedCountry?.id.toString() ?? "",
        'terms_conditions': 'on',
      });

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (data['validation_errors'] != null) {
        print(data);
        if (data['validation_errors']['email'] != null) {
          showToast(data['validation_errors']['email'].first, cc.red);
        } else if (data['validation_errors']['username'] != null) {
          showToast(data['validation_errors']['username'].first, cc.red);
        } else if (data['validation_errors']['phone'] != null) {
          showToast(data['validation_errors']['phone'].first, cc.red);
        } else {
          showToast(AppLocalizations.of(context)!.sign_up_failed, cc.red);
        }
        setLoadingSignUp(false);
        return;
      } else if (response.statusCode == 200) {
        final otpCode = await Provider.of<OtpService>(context, listen: false)
            .sendOTP(context, email);
        if (otpCode != null) {
          await Navigator.of(context)
              .push(PageRouteBuilder(
                  pageBuilder: (context, animation, anotherAnimation) {
            return EnterOtpView(
              otpCode,
              fromRegister: true,
            );
          }, transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(curve: Curves.decelerate, parent: animation);
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          }))
              .then((value) async {
            if (value == true) {
              await Provider.of<OtpService>(context, listen: false).verifyEmail(
                context,
                data['users']['id'],
              );
              Provider.of<SaveSignInInfoService>(context, listen: false)
                  .saveToken(data['token']);
              await Provider.of<ProfileInfoService>(context, listen: false)
                  .fetchProfileInfo(context);
              Navigator.pop(context, true);

              showToast(
                  AppLocalizations.of(context)!.sign_up_succeeded, cc.green);
              setLoadingSignUp(false);
              return;
            }
            showToast(
                AppLocalizations.of(context)!.oTP_verification_failed, cc.red);
          });
        }
        setLoadingSignUp(false);
      } else {
        print(response.reasonPhrase);
        setLoadingSignUp(false);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      setLoadingSignUp(false);
    } catch (err) {
      print(err);
      showToast(err.toString(), cc.red);
      setLoadingSignUp(false);
    }
  }
}
