import 'package:flutter/widgets.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'spannable_grid_cell_data.dart';

class SpannableGridDelegate extends MultiChildLayoutDelegate {
  SpannableGridDelegate({
    required this.cells,
    required this.columns,
    required this.rows,
    required this.onCellSizeCalculated,
    // this.rowHeight,
    required this.spacing,
    this.gridSize = SpannableGridSize.parentWidth,
  });

  final Map<Object, SpannableGridCellData> cells;

  final int columns;

  // final double? rowHeight;

  final int rows;

  final double spacing;

  final SpannableGridSize gridSize;

  final Function(Size size) onCellSizeCalculated;

  @override
  void performLayout(Size size) {
    final double cellHeight = 100;
    final double cellWidth = size.width / columns;
    print(
        "performLayout: size: $size, cellHeight: $cellHeight, cellWidth: $cellWidth");

    onCellSizeCalculated(
        Size(cellWidth, cellHeight)); //cellWidth, cellHeight));
    for (SpannableGridCellData cell in cells.values) {
      final childHeight = cell.rowSpan * cellHeight - spacing * 2;
      final childWidth = cell.columnSpan * cellWidth - spacing * 2;
      cell.height = childHeight;
      layoutChild(
          cell.id,
          BoxConstraints(
            minWidth: childWidth,
            maxWidth: childWidth,
            minHeight: childHeight,
            maxHeight: childHeight,
          ));
      positionChild(
          cell.id,
          Offset((cell.column - 1) * cellWidth + spacing,
              (cell.row - 1) * cellHeight + spacing));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;
}
