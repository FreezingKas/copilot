import 'package:copilot/left_column.dart';
import 'package:copilot/right_column.dart';
import 'package:flutter/material.dart';

class LineOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: LeftColumn(),
              flex: 1,
            ),
            Flexible(
              child: RightColumn(),
              flex: 1,
            ),
          ],
        ),
      );
  }
}
