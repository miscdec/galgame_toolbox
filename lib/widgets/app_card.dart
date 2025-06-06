import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';

class AppCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? subtitle;
  final String? author;
  final String? version;
  final String? license;
  final String? playingTime;
  final Function()? launch;

  const AppCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.subtitle,
    this.author,
    this.version,
    this.license,
    this.playingTime,
    this.launch,
  });

  @override
  Widget build(BuildContext context) {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Card(
        child: Padding(
      padding: EdgeInsets.fromViewPadding(ViewPadding.zero, devicePixelRatio),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: FluentTheme.of(context).typography.body?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FluentTheme.of(context).typography.title?.fontStyle,
                  fontSize: 16,
                  letterSpacing: 0.0,
                ),
          ),
          SpacingRow(
            spacing: 5,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                FluentIcons.schedule_event_action,
                color: Color(0xFF6C5CE7),
                size: 14,
              ),
              Text(
                playingTime ?? "0:00",
                style: FluentTheme.of(context).typography.body?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontStyle:
                          FluentTheme.of(context).typography.body?.fontStyle,
                      color: Color(0xFFCCCCCC),
                      fontSize: 12,
                      letterSpacing: 0.0,
                  overflow:  TextOverflow.ellipsis,
                    ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
