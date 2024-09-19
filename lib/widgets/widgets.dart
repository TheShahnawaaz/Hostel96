import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';

import '../utils/constants/colors.dart';

import 'package:iconsax/iconsax.dart';

import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = TColors.lightGrey,
    this.fit,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = 10,
    this.margin,
  });

  final double? width;
  final double? height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: Image(
            fit: fit,
            image: isNetworkImage
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CustomImageLoader(
                width: width ?? double.infinity,
                height: height ?? 200,
                loadingProgress: loadingProgress,
                showProgressIndicator: true,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return ImageNotFound(
                height: height ?? 200,
                width: width ?? double.infinity,
              );
            },
          ),
        ),
      ),
      // Container
    );
  }
}

class VerticalImageTextCity extends StatelessWidget {
  const VerticalImageTextCity({
    super.key,
    required this.image,
    required this.title,
    this.textColor = TColors.dark,
    this.backgroundColor,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? TColors.dark : TColors.light),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.all(0),
              child: ClipOval(
                // Wrap the Image with ClipOval
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  width: 70, // Set the width and height to match the Container
                  height: 70,
                ),
              ),
            ),
            const SizedBox(height: TSizes.sm),
            SizedBox(
              width: 75,
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class CurveEdgesWidget extends StatelessWidget {
  const CurveEdgesWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvesEdges(),
      child: Container(
        color: TColors.primary,
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -250,
                child: TCircularContainer(
                  backgroundColor: TColors.textWhite.withOpacity(0.1),
                  width: 400,
                  height: 400,
                  radius: 200,
                )),
            Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(0.1),
                    width: 400,
                    height: 400,
                    radius: 200)),
            child,
          ],
        ),
      ),
    );
  }
}

class CustomCurvesEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstStart = Offset(0, size.height - 20);
    final firstEnd = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    final secondStart = Offset(0, size.height - 20);
    final secondEnd = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    final thirdStart = Offset(size.width, size.height - 20);
    final thirdEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(
        thirdStart.dx, thirdStart.dy, thirdEnd.dx, thirdEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.child,
    required this.backgroundColor,
    this.margin,
  });

  final double? width;
  final double? height;
  final double? radius;
  final double? padding;
  final Widget? child;
  final Color backgroundColor;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 100),
        color: backgroundColor,
      ), // BoxDecoration
    ); // Container
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final IconData icon;
  final bool autoFocus;

  const SearchTextField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search',
    this.icon = Iconsax.search_normal,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          prefixIcon: Icon(icon),
          fillColor: isDarkMode ? TColors.dark : TColors.light,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        style: Theme.of(context).textTheme.bodySmall,
        autofocus: autoFocus,
      ),
    );
  }
}

// Make sure to add the lottie package in pubspec.yaml

class TAnimationLoaderWidget extends StatelessWidget {
  /// A widget for displaying an animated loading indicator with optional text and action button.

  /// Parameters:
  /// - text: The text to be displayed below the animation.
  /// - animation: The path to the lottie animation file.
  /// - showAction: Whether to show an action button below the text.
  /// - actionText: The text to be displayed on the action button.
  /// - onActionPressed: Callback function to be executed when the action button is pressed.

  const TAnimationLoaderWidget({
    Key? key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust the width as needed
            height: 250,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (showAction)
            SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                child: Text(
                  actionText ??
                      'Action', // Use actionText if provided, otherwise default to 'Action'
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({
    required String message,
  }) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: THelperFunctions.isDarkMode(Get.context!)
                ? TColors.dark
                : TColors.light,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message,
            style: Theme.of(Get.context!).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }

  static void successSnackbar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: TColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Iconsax.check, color: TColors.white),
    );
  }

  static void warningSnackbar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }

  static void errorSnackbar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Iconsax.close_square, color: TColors.white),
    );
  }

  static void infoSnackbar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Iconsax.information, color: TColors.white),
    );
  }
}

// MyDivider class
class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Divider(
      thickness: 5,
      height: 30,
      color: dark
          ? const Color.fromARGB(255, 70, 71, 76)
          : const Color.fromARGB(255, 240, 240, 240),
    );
  }
}

class CustomImageLoader extends StatelessWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  final ImageChunkEvent? loadingProgress;
  final bool showProgressIndicator;

  CustomImageLoader({
    Key? key,
    required this.width,
    required this.height,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.loadingProgress,
    this.showProgressIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        if (showProgressIndicator && loadingProgress != null)
          Center(
            child: CircularProgressIndicator(
              color: TColors.primary,
              value: loadingProgress!.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded /
                      loadingProgress!.expectedTotalBytes!
                  : null,
            ),
          ),
      ],
    );
  }
}

class ImageNotFound extends StatelessWidget {
  final double height;
  final double width;

  const ImageNotFound({
    Key? key,
    this.height = 200.0,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      height: height,
      width: width,
      color: dark
          ? const Color.fromARGB(255, 70, 71, 76)
          : const Color.fromARGB(255, 240, 240, 240),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: dark ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              'Image not found',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: dark ? Colors.white : Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TAnimationLogoWidget extends StatelessWidget {
  /// A widget for displaying an animated circular loading animation around a logo.
  ///
  /// Parameters:
  /// - logo: The widget representing your logo.
  /// - animation: The path to the lottie animation file (should be a circular loading animation).
  /// - animationSize: The size of the animation.
  /// - backgroundColor: The background color of the animation.
  const TAnimationLogoWidget({
    Key? key,
    // required this.logo,
    // required this.animation,
    this.animationSize = 80.0,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  // final Widget logo;
  // final String animation;
  final double animationSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: animationSize,
        height: animationSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular Lottie Animation
            // Lottie.asset(
            //   animation,
            //   width: animationSize,
            //   height: animationSize,
            //   fit: BoxFit.cover,
            // ),
            // Logo in the Center
            Image(
              image: const AssetImage(TImages.lightAppLogo),
              width: animationSize * 0.6,
              height: animationSize * 0.6,
            ),
            LoadingAnimationWidget.threeArchedCircle(
                color: TColors.primary, size: animationSize),
          ],
        ),
      ),
    );
  }
}
