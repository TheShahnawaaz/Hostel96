import 'package:flutter/material.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text(
                    'Privacy Policy',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  showBackArrow: true,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: TTexts.privacyPolicyTexts,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        p: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: dark ? Colors.white : Colors.black,
                            ),
                        h2: Theme.of(context).textTheme.headline6!.copyWith(
                              color: dark ? Colors.white : Colors.black,
                            ),
                        listBullet:
                            Theme.of(context).textTheme.bodyText2!.copyWith(
                                  color: dark ? Colors.white : Colors.black,
                                ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
