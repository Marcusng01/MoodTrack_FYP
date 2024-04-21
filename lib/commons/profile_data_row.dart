import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileDataRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String data;
  final VoidCallback onTap;
  const ProfileDataRow({
    super.key,
    required this.title,
    required this.data,
    required this.onTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (subtitle == "") {
      return Column(
        children: [
          const Divider(
            height: 3,
            color: AppColors
                .lightBlueSurface, // Optional: Specify the color of the divider
            thickness: 3, // Optional: Specify the thickness of the divider
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Text(title, style: AppTextStyles.mediumBlackText)),
                  Expanded(
                      flex: 2,
                      child: Text(data, style: AppTextStyles.mediumBlackText))
                ]),
          )
        ],
      );
    } else {
      return InkWell(
          onTap: onTap,
          child: Column(
            children: [
              const Divider(
                height: 3,
                color: AppColors
                    .lightBlueSurface, // Optional: Specify the color of the divider
                thickness: 3, // Optional: Specify the thickness of the divider
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: AppTextStyles.mediumBlackText),
                                Text(subtitle,
                                    style: AppTextStyles.smallBlueText)
                              ])),
                      Expanded(
                          flex: 2,
                          child:
                              Text(data, style: AppTextStyles.mediumBlackText))
                    ]),
              )
            ],
          ));
    }
  }
}
