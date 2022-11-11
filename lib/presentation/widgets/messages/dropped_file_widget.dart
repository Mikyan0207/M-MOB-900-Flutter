import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'dropped_file.dart';

class DroppedFileWidget extends StatelessWidget {
  const DroppedFileWidget({
    required Key key,
    required this.file,
  }) : super(key: key);
  final DroppedFile file;

  @override
  Widget build(BuildContext context) => buildImage();

  Widget buildImage() {

    if (file.name.isEmptyOrNull) {
      return buildEmptyFile('No File');
    }

    return Container(
      width: 120,
      height: 120,
      color: Colors.blue.shade300,
      child: Center(
        child: Image.network(
          file.url,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, _) =>
              buildEmptyFile('No Preview'),
        ),
      ),
    );
  }

  Widget buildEmptyFile(String text) => Container(
        width: 120,
        height: 120,
        color: Colors.blue.shade300,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}
