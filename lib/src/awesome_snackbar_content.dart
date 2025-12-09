import 'package:awesome_snackbar_content/src/assets_path.dart';
import 'package:awesome_snackbar_content/src/content_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class AwesomeSnackbarContent extends StatelessWidget {
  const AwesomeSnackbarContent(
      {Key? key,
      this.color,
      this.titleTextStyle,
      this.backgroundCircle,
      this.messageTextStyle,
      required this.title,
      required this.message,
      required this.contentType,
      this.inMaterialBanner = false,
      this.leftCloseIconPosition,
      this.closeIconColor,
      this.topCloseIconPosition,
      this.rightCloseIconPosition,
      this.bottomCloseIconPosition,
      this.icon})
      : super(key: key);

  /// `IMPORTANT NOTE` for SnackBar properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// behavior: SnackBarBehavior.floating
  /// elevation: 0.0

  /// /// `IMPORTANT NOTE` for MaterialBanner properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// forceActionsBelow: true,
  /// elevation: 0.0
  /// [inMaterialBanner = true]

  /// title is the header String that will show on top
  final String title;
  final Color? backgroundCircle;
  final Widget? icon;
  final double? leftCloseIconPosition;
  final double? topCloseIconPosition;
  final double? rightCloseIconPosition;
  final double? bottomCloseIconPosition;

  /// message String is the body message which shows only 2 lines at max
  final String message;

  /// `optional` color of the SnackBar/MaterialBanner body
  final Color? color;
  final Color? closeIconColor;

  /// contentType will reflect the overall theme of SnackBar/MaterialBanner: failure, success, help, warning
  final ContentType contentType;

  /// if you want to use this in materialBanner
  final bool inMaterialBanner;

  /// if you want to customize the font style of the title
  final TextStyle? titleTextStyle;

  /// if you want to customize the font style of the message
  final TextStyle? messageTextStyle;

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final Size size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 600;
    bool isTablet = size.width > 600 && size.width <= 1200;

    /// for reflecting different color shades in the SnackBar
    final HSLColor hsl = HSLColor.fromColor(color ?? contentType.color!);
    final HSLColor hslDark =
        hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    double horizontalPadding = 0.0;
    double leftSpace = size.width * 0.12;
    double rightSpace = size.width * 0.12;

    if (isMobile) {
      horizontalPadding = size.width * 0.01;
    } else if (isTablet) {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.08;
    } else {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.12;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        /// background container
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            width: size.width,
            decoration: BoxDecoration(
              color: color ?? contentType.color,
              borderRadius: BorderRadius.circular(30),
            ),

            /// Splash SVG asset
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(20),
            //     ),
            //     child: SvgPicture.asset(
            //       AssetsPath.bubbles,
            //       height: 40.h,
            //       width: size.width * 0.05,
            //       colorFilter:
            //           _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
            //       package: 'awesome_snackbar_content',
            //     ),
            //   ),
            // ),

            // Bubble Icon

            /// content
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    children: <Widget>[
                      /// `title` parameter
                      ///
                      Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: backgroundCircle ?? Colors.white,
                          ),
                          child: Center(
                              child: icon ??
                                  SvgPicture.asset(
                                    assetSVG(contentType),
                                    height: 20.h,
                                    width: 20.w,
                                    colorFilter: _getColorFilter(
                                        hslDark.toColor(), ui.BlendMode.srcIn),
                                    package: 'awesome_snackbar_content',
                                  ))),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          //textAlign: TextAlign.center,
                          message,
                          style: messageTextStyle ??
                              TextStyle(
                                fontFamily: "IBMPlexArabic",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),

                Positioned(
                  top: topCloseIconPosition,
                  right: rightCloseIconPosition,
                  bottom: bottomCloseIconPosition,
                  left: leftCloseIconPosition,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (inMaterialBanner) {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                            return;
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: Icon(
                          Icons.close,
                          color: closeIconColor ?? Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ],
                  ),
                ),

                /// `message` body text parameter
                // Expanded(
                //   child: Text(
                //     textAlign: TextAlign.center,
                //     message,
                //     style: messageTextStyle ??
                //         TextStyle(
                //           fontSize: size.height * 0.016,
                //           color: Colors.white,
                //         ),
                //   ),
                // ),
                // SizedBox(
                //   height: size.height * 0.015,
                // ),
              ],
            ))
      ],
    );
  }

  /// Reflecting proper icon based on the contentType
  String assetSVG(ContentType contentType) {
    switch (contentType) {
      case ContentType.failure:

        /// failure will show `CROSS`
        return AssetsPath.failure;
      case ContentType.success:

        /// success will show `CHECK`
        return AssetsPath.success;
      case ContentType.warning:

        /// warning will show `EXCLAMATION`
        return AssetsPath.warning;
      case ContentType.help:

        /// help will show `QUESTION MARK`
        return AssetsPath.help;
      default:
        return AssetsPath.failure;
    }
  }

  static ColorFilter? _getColorFilter(
          ui.Color? color, ui.BlendMode colorBlendMode) =>
      color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
}
