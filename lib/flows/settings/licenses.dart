import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';

class LicensesRoute extends StatelessWidget {
  const LicensesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var data = <LicenseEntry>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).licenses),
      ),
      body: FutureBuilder(
        future: () async {
          data = await LicenseRegistry.licenses.toList();
          return data;
        }(),
        builder:
            (BuildContext context, AsyncSnapshot<List<LicenseEntry>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: (context, n) {
              return ListTile(
                title: Text(
                  data[n].packages.join(', '),
                ),
                subtitle: Text(
                  data[n].paragraphs.map((e) => e.text).join('\n\n'),
                ),
              );
            },
            itemCount: data.length,
          );
        },
      ),
    );
  }
}
