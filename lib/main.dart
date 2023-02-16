import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'configurations.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void logger(dynamic msg, [String? hint]) {
  final h = hint ?? "LOGGER";
  log("[$h] - ${msg.toString()} - [$h]");
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

class _MyHomePageState extends State<MyHomePage> {
  final cells = <SpannableGridCellData>[];
  List<SidebarMd> sidebar = [];

  @override
  void initState() {
    super.initState();
    cells.add(SpannableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 2,
      rowSpan: 2,
      id: "User 1",
      acceptOnlyHorizontal: true,
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
      acceptOnlyVertical: true,
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
      sidebar.add(SidebarMd(id: i));
    }

    gridWidgets.init();
  }

  final gridWidgets = GridWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Schedule Example Test"),
      ),
      body: gridWidgets.getFullGrid(sidebar, cells),
    );
  }
}
