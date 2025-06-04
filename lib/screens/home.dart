
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/link.dart';



class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('Fluent UI for Flutter Showcase App'),
        commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Link(
            uri: Uri.parse('https://github.com/bdlukaa/fluent_ui'),
            builder: (context, open) => Semantics(
              link: true,
              child: Tooltip(
                message: 'Source code',
                child: IconButton(
                  icon: const Icon(FluentIcons.open_source, size: 24.0),
                  onPressed: open,
                ),
              ),
            ),
          ),
        ]),
      ),
      children: [
        const SizedBox(height: 22.0),
        Row(children: [
          Text('SPONSORS', style: theme.typography.bodyStrong),
          const SizedBox(width: 4.0),
          const Icon(FluentIcons.heart_fill, size: 16.0),
        ]),
        const SizedBox(height: 4.0),
        Text('CONTRIBUTORS', style: theme.typography.bodyStrong),
      ],
    );
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    super.key,
    required this.imageUrl,
    required this.username,
  });

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}