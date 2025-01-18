import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultThemes {
  InputDecorationTheme? inputDecorationTheme(BuildContext context, cc) =>
      InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: cc.greyHint,
              fontSize: 14,
            ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cc.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cc.greyBorder, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cc.red, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cc.red, width: 1),
        ),
      );

  CheckboxThemeData? checkboxTheme(BuildContext context, cc) =>
      CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          width: 1,
          color: cc.secondaryColor,
        ),
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cc.secondaryColor;
          }
          return cc.pureWhite;
        }),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1,
              color: cc.secondaryColor,
            )),
      );
  RadioThemeData? radioThemeData(BuildContext context, cc) => RadioThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: WidgetStateColor.resolveWith((states) => cc.secondaryColor),
        visualDensity: VisualDensity.compact,
      );

  OutlinedButtonThemeData? outlinedButtonTheme(BuildContext context, cc) =>
      OutlinedButtonThemeData(
          style: ButtonStyle(
        overlayColor:
            WidgetStateColor.resolveWith((states) => Colors.transparent),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: cc.primaryColor,
            );
          }
          return BorderSide(
            color: cc.greyBorder,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return cc.primaryColor;
          }
          return cc.greyHint;
        }),
      ));

  ElevatedButtonThemeData? elevatedButtonTheme(BuildContext context, cc) =>
      ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((states) => 0),
        overlayColor:
            WidgetStateColor.resolveWith((states) => Colors.transparent),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return cc.blackColor;
          }
          return cc.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return cc.pureWhite;
          }
          return cc.pureWhite;
        }),
      ));

  appBarTheme(BuildContext context, cc) => AppBarTheme(
        backgroundColor: cc.pureWhite,
        elevation: 3,
        surfaceTintColor: cc.pureWhite,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      );
}
