import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/model/article_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late List<ArticleData> _feedItems;

  @override
  void initState() {
    super.initState();
    _feedItems = [];
    getRssFeedData().then((document) {
      if (document != null) {
        setState(() {
          final feed = document.findElements('feed').first;
          final entries = feed.findElements('entry');
          for (final entry in entries) {
            final title = entry.findElements('title').first.text;
            final link = entry.findElements('link').first.getAttribute('href');
            final updated = entry.findElements('updated').first.text;
            final pubDate = DateTime.parse(updated);
            _feedItems.add(ArticleData(
              title: title,
              link: link,
              pubDate: pubDate,
            ));
          }
        });
      }
    });
  }

  Future<XmlDocument?> getRssFeedData() async {
    try {
      final client = http.Client();
      final response =
          await client.get(Uri.parse('https://www.cshub.com/rss/reports'));
      return XmlDocument.parse(response.body);
    } catch (e, s) {
      print("Error in getRssFeedData:");
      print(e);
      print(s);
      return null;
    }
  }

  Future<void> openUrl(String url) async {
    try {
      final target = Uri.parse(url);
      if (await canLaunchUrl(target)) {
        print("Trying to open url: $url");
        await launchUrl(target);
      } else {
        print("Error in openUrl: Could not launch $url");
      }
    } catch (e, s) {
      print("Error in openUrl:");
      print(e);
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: _feedItems.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _feedItems[index];
              return ListTile(
                title: Text(item.title ?? ''),
                subtitle: Text(item.pubDate?.toIso8601String() ?? ''),
                onTap: () => openUrl(item.link ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
