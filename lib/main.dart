import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:spannable_grid/spannable_grid.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Data {
  final String username;
  final String location;
  final Time time;

  Data(this.username, this.location, this.time);
}

class Time {
  int hour;
  int minute;
  bool is24Format;
  bool get isAM => hour < 12;
  Time(this.hour, {this.minute = 0, this.is24Format = true}) {
    if (!is24Format && hour > 12) {
      hour -= 12;
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final cells = <SpannableGridCellData>[];
  final List<Time> times = [];

  List<Map> users = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 24; i++) {
      times.add(Time(i));
    }
    cells.add(SpannableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 2,
      rowSpan: 1,
      id: "User 1",
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            "Tile 2x2",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: cells.last.column + cells.last.columnSpan,
      row: 1,
      columnSpan: 1,
      rowSpan: 1,
      id: "User 0",
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            "Tile 1x1",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ));
    for (int i = 0; i < 10; i++) {
      users.add({
        "name": "User ${i + 1}",
        "col": "Col ${i + 1}",
        "row": "Row ${i + 1}",
        "itemCount": i == 0 ? 2 : 1,
      });
    }

    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    _verticalControllersGroup = LinkedScrollControllerGroup();
    _verticalController1 = _verticalControllersGroup.addAndGet();
    _verticalController2 = _verticalControllersGroup.addAndGet();
  }

  double w = 1600;
  double h = 500;

  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;

  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _verticalController1;
  late ScrollController _verticalController2;

  double get headerHeight => 32;
  double get headerWidth => w / times.length;
  @override
  Widget build(BuildContext context) {
    int rowsCount = 0;
    for (int i = 0; i < users.length; i++) {
      rowsCount = rowsCount + (users[i]["itemCount"]! as int);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Schedule Example Test"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: headerHeight,
                width: 200,
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
              ),
              SizedBox(
                height: headerHeight,
                width: 800,
                child: ListView.builder(
                  controller: _horizontalController2,
                  scrollDirection: Axis.horizontal,
                  itemCount: times.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: headerHeight,
                      width: headerWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border:
                            Border(right: BorderSide(color: Colors.grey[400]!)),
                      ),
                      child: Center(
                        child: Text(
                          "${times[index].hour}:${times[index].minute <= 0 ? "0" : ""}${times[index].minute}",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 500,
                width: 200,
                color: Colors.grey[300],
                child: SingleChildScrollView(
                  controller: _verticalController1,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < users.length; i++)
                          Container(
                            height: (users[i]['itemCount'] * 100).toDouble(),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]!),
                                  right: BorderSide(color: Colors.grey[400]!)),
                            ),
                            child: Center(
                              child: Text(
                                users[i]['name'],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Scrollbar(
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
                      height: users.length * 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalController1,
                        child: SizedBox(
                          width: w,
                          child: SizedBox(
                            child: SpannableGrid(
                              style: SpannableGridStyle(
                                backgroundColor: Colors.grey[500]!,
                                spacing: 2,
                                selectedCellDecoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                              ),
                              editingStrategy:
                                  const SpannableGridEditingStrategy(
                                exitOnTap: true,
                                immediate: true,
                                enterOnLongTap: false,
                                moveOnlyToNearby: true,
                              ),
                              showGrid: true,
                              emptyCellView: (rowIdx, colIdx, draggingData) =>
                                  EmptyWidget(rowIdx, colIdx,
                                      draggingData: draggingData),
                              columns: times.length,
                              rows: rowsCount,
                              cells: cells,
                              onCellChanged: (cell) {
                                print('Cell ${cell?.height} changed');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

//
// renderer: (rendererContext) {
// return LongPressDraggable(
// childWhenDragging: const SizedBox(),
// data: rendererContext.rowIdx,
// onDragStarted: () {},
// onDragEnd: (details) {
// print(
// "From: Column Index = ${stateManager?.columnIndex(rendererContext.column)}");
// print(details.offset);
// },
// feedback: Container(
// color: Colors.blueAccent,
// child: Text(rendererContext.cell.value.toString()),
// ),
// child: DragTarget(
// builder: (context, candidateData, rejectedData) =>
// Text(rendererContext.cell.value.toString()),
// onAccept: (data) {
// print("From: Row Index = $data");
// final colIdx =
// stateManager?.columnIndex(rendererContext.column);
// final fromRowIdx = data as int;
// final r = stateManager?.rows[fromRowIdx];
// moveCellToCell(1, 0);
// },
// ),
// );
// },
