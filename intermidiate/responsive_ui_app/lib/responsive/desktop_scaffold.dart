import 'package:flutter/material.dart';
import 'package:responsive_ui_app/constant.dart';
import 'package:responsive_ui_app/utils/my_box.dart';
import 'package:responsive_ui_app/utils/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: Row(
        children: [
          // open drawer
          myDrawer,

          // rest of the body
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // 4 boxes on top
                AspectRatio(
                  aspectRatio: 4,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: 4,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                      itemBuilder: (context, index) {
                        return MyBox();
                      },
                    ),
                  ),
                ),

                // title below it
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return MyTile();
                    },
                  ),
                ),

                // tiles
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
