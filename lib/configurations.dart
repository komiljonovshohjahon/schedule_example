import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:spannable_grid/spannable_grid.dart';

class TimeMd {
  int hour;
  final int minute;
  final bool is24Format;
  bool get isAM => hour < 12;
  TimeMd(this.hour, {this.minute = 0, this.is24Format = true}) {
    if (!is24Format && hour > 12) {
      hour -= 12;
    }
  }
}

class SidebarMd {
  final int id;
  final int groupCount;

  SidebarMd({required this.id, this.groupCount = 1});
}

class Configs {
  final List<TimeMd> times = [for (int i = 0; i < 24; i++) TimeMd(i)];

  //Grid Data
  final double cellHeight = 80; // in Pixels
  // has some calculation,
  // so try with preferred values
  final double cellWidth = 16 * 100;
  final double cellSpacing = 2;
  int getRowCount(List<SidebarMd> sidebar) {
    int rowsCount = 0;
    for (int i = 0; i < sidebar.length; i++) {
      rowsCount = rowsCount + sidebar[i].groupCount;
    }
    return rowsCount;
  }

  double get gridHeaderWidth => cellWidth / times.length;
  final double gridFullWidth = 800;
  final double gridFullHeight = 500;

  //Sidebar Data
  final double sidebarHeaderHeight = 32;
  final double sidebarWidth = 200;
}

class GridWidgets {
  final Configs _config = Configs();

  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;

  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _verticalController1;
  late ScrollController _verticalController2;

  ///Must run this function before using any other function
  void init() {
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    _verticalControllersGroup = LinkedScrollControllerGroup();
    _verticalController1 = _verticalControllersGroup.addAndGet();
    _verticalController2 = _verticalControllersGroup.addAndGet();
  }

  void dispose() {
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _verticalController1.dispose();
    _verticalController2.dispose();
  }

  Widget _getSidebarHeader() {
    return Container(
      height: _config.sidebarHeaderHeight,
      width: _config.sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        border: Border(
          right: BorderSide(color: Colors.grey[400]!),
          bottom: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      child: const Center(
        child: Text(
          "Users",
        ),
      ),
    );
  }

  Widget _getGridHeader() {
    return SizedBox(
      height: _config.sidebarHeaderHeight,
      width: _config.gridFullWidth,
      child: ListView.builder(
        controller: _horizontalController2,
        scrollDirection: Axis.horizontal,
        itemCount: _config.times.length,
        itemBuilder: (context, index) {
          return Container(
            height: _config.sidebarWidth,
            width: _config.gridHeaderWidth,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border(right: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Center(
              child: Text(
                "${_config.times[index].hour}:${_config.times[index].minute <= 0 ? "0" : ""}${_config.times[index].minute}",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getSidebarItems(List<SidebarMd> sidebar) {
    return Container(
      height: _config.gridFullHeight,
      width: _config.sidebarWidth,
      color: Colors.grey[300],
      child: SingleChildScrollView(
        controller: _verticalController1,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < sidebar.length; i++)
                Container(
                  height:
                      (sidebar[i].groupCount * _config.cellHeight).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400]!),
                        right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Center(
                    child: Text(
                      sidebar[i].id.toString(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGridItems(
      List<SidebarMd> sidebar, List<SpannableGridCellData> cells) {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      controller: _horizontalController1,
      child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          controller: _verticalController2,
          child: Container(
            color: Colors.grey[400],
            width: 800,
            height: _config.getRowCount(sidebar) * _config.cellHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController1,
              child: SizedBox(
                width: _config.cellWidth,
                child: SizedBox(
                  child: SpannableGrid(
                    style: SpannableGridStyle(
                      cellHeight: _config.cellHeight,
                      emptyCellDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black, width: .5),
                      ),
                      backgroundColor: Colors.grey[500]!,
                      spacing: 2,
                      selectedCellDecoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                    editingStrategy: const SpannableGridEditingStrategy(
                      exitOnTap: true,
                      immediate: true,
                      enterOnLongTap: false,
                      moveOnlyToNearby: true,
                    ),
                    showGrid: true,
                    emptyCellView: (rowIdx, colIdx, draggingData) =>
                        EmptyWidget(rowIdx, colIdx, draggingData: draggingData),
                    columns: _config.times.length,
                    rows: _config.getRowCount(sidebar),
                    cells: cells,
                    onCellChanged: (cell) {
                      print('Cell ${cell?.id} changed');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFullGrid(
      List<SidebarMd> sidebar, List<SpannableGridCellData> cells) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Sidebar Header (only 1 item)
            _getSidebarHeader(),
            // Grid Header (list)
            _getGridHeader(),
          ],
        ),
        Row(
          children: [
            // Sidebar (list)
            _getSidebarItems(sidebar),
            // Grid (list)
            _getGridItems(sidebar, cells),
          ],
        ),
      ],
    );
  }
}

class EmptyWidget extends StatefulWidget {
  final int rowIdx;
  final int colIdx;
  final SpannableGridCellData? draggingData;
  const EmptyWidget(this.rowIdx, this.colIdx, {Key? key, this.draggingData})
      : super(key: key);

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool _isHovering = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: _onHover,
        onTap: () {
          print(
              "EmptyWidget: rowIdx = ${widget.rowIdx}, colIdx = ${widget.colIdx}");
        },
        child: _isHovering
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.lime[400]!,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black, width: .5)))
            : DecoratedBox(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black, width: .5),
              )));
  }
}
