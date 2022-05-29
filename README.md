# lining_drawer

A customized drawer for your flutter.

### Installation and usage ###

Add package to your pubspec:

```yaml
dependencies:
  lining_drawer: any # or the latest version on Pub
```

### USAGE

```dart 

import 'package:lining_drawer/lining_drawer.dart';

...

final LiningDrawerController _controller = LiningDrawerController();

...
LiningDrawer(
  direction: isRTL
      ? DrawerDirection.fromRightToLeft
      : DrawerDirection.fromLeftToRight,
  openDuration: const Duration(milliseconds: 250),
  controller: _controller,
  drawer: yourDrawerWidget(),
  child: Scaffold(),
  // openDuration: const Duration(milliseconds: 250),
  // closeDuration: const Duration(milliseconds: 250),
  // style: const LiningDrawerStyle(
  //   bottomColor: Color(0xFF3a3b3c),
  //   middleColor: Colors.red,
  //   mainColor: Colors.white,
  //   bottomOpenRatio: 1.0,
  //   middleOpenRatio: 0.90,
  //   mainOpenratio: 0.82,
  // ).....
  
);

```

