import 'package:flutter/material.dart';
import 'package:lining_drawer/lining_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRTL = false;
  final LiningDrawerController _controller = LiningDrawerController();

  @override
  Widget build(BuildContext context) {
    return LiningDrawer(
      direction: isRTL
          ? DrawerDirection.fromRightToLeft
          : DrawerDirection.fromLeftToRight,
      openDuration: const Duration(milliseconds: 250),
      controller: _controller,
      drawer: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "NETFLIX",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.toggleDrawer();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _controller.toggleDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text("From Right to Left"),
                  value: isRTL,
                  onChanged: (_value) {
                    setState(() {
                      isRTL = _value;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
