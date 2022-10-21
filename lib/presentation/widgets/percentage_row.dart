import 'package:flutter/material.dart';

class PercentageRow extends StatelessWidget {
  const PercentageRow({
    super.key,
    required this.percentages,
    required this.children,
  });

  final List<double> percentages;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: percentages
          .map((double p) => FlexColumnWidth(p))
          .toList()
          .asMap(),
      children: <TableRow>[
        TableRow(
          children: children.map((Widget e) => IntrinsicHeight(child: e))
              .toList(),
        ),
      ],
    );
  }
}
