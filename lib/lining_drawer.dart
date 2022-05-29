import 'package:flutter/material.dart';

enum DrawerDirection { fromRightToLeft, fromLeftToRight }

class LiningDrawer extends StatefulWidget {
  /// Child widget. (Usually widget that represent a screen)
  final Widget child;

  /// Drawer widget. (The widget the inside the menu).
  final Widget drawer;

  /// Controller that controls the drawer open & close.
  final LiningDrawerController controller;

  /// opening animation duration.
  final Duration openDuration;

  /// closing animation duration.
  final Duration closeDuration;

  /// drawer style [LiningDrawerStyle]
  final LiningDrawerStyle style;

  /// Direction of drawer
  final DrawerDirection direction;

  const LiningDrawer({
    Key? key,
    required this.child,
    required this.controller,
    required this.drawer,
    this.openDuration = const Duration(milliseconds: 300),
    this.closeDuration = const Duration(milliseconds: 200),
    this.style = const LiningDrawerStyle(),
    this.direction = DrawerDirection.fromLeftToRight,
  }) : super(key: key);

  @override
  State<LiningDrawer> createState() => _LiningDrawerState();
}

class _LiningDrawerState extends State<LiningDrawer>
    with TickerProviderStateMixin {
  final _kMap = {
    DrawerDirection.fromLeftToRight: -1,
    DrawerDirection.fromRightToLeft: 1
  };
  late final AnimationController _firstShadowController,
      _secondShadowController,
      mainDrawerController;
  ValueNotifier<bool> isOpened = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _firstShadowController = AnimationController(
      vsync: this,
      duration: widget.openDuration,
      upperBound: widget.style.bottomOpenRatio,
      reverseDuration: widget.closeDuration,
    )..addListener(() {
        if (_firstShadowController.value >=
                (widget.style.bottomOpenRatio / 2) &&
            !_secondShadowController.isAnimating &&
            !isOpened.value) {
          _secondShadowController.forward();
        }
        if (_firstShadowController.isDismissed) {
          isOpened.value = false;
        }
      });

    _secondShadowController = AnimationController(
      vsync: this,
      duration: widget.openDuration,
      reverseDuration: widget.closeDuration,
      upperBound: widget.style.middleOpenRatio,
    )..addListener(() {
        if (_secondShadowController.value >=
                (widget.style.middleOpenRatio / 2) &&
            !mainDrawerController.isAnimating &&
            !isOpened.value) {
          mainDrawerController.forward();
        }
        if (_secondShadowController.isDismissed) {
          _firstShadowController.reverse();
        }
      });

    mainDrawerController = AnimationController(
      vsync: this,
      duration: widget.openDuration,
      reverseDuration: widget.closeDuration,
      upperBound: widget.style.mainOpenratio,
    )..addListener(() {
        if (mainDrawerController.isCompleted) {
          isOpened.value = true;
        }
        if (mainDrawerController.isDismissed) {
          _secondShadowController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _firstShadowController.dispose();
    _secondShadowController.dispose();
    mainDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _kPadding = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width * widget.style.mainOpenratio);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: [
            widget.child,
            AnimatedBuilder(
                animation: _firstShadowController,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(
                        (MediaQuery.of(context).size.width *
                                (1 - _firstShadowController.value)) *
                            _kMap[widget.direction]!,
                        0),
                    child: Container(
                      color: widget.style.bottomColor,
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: _secondShadowController,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(
                        (MediaQuery.of(context).size.width *
                                (1 - _secondShadowController.value)) *
                            _kMap[widget.direction]!,
                        0),
                    child: ValueListenableBuilder<bool>(
                        valueListenable: isOpened,
                        builder: (_, _isOpened, __) {
                          return Container(
                            decoration: BoxDecoration(
                              color: widget.style.middleColor,
                              boxShadow: !_isOpened
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(2, 2),
                                        spreadRadius: 3.0,
                                        blurRadius: 6.0,
                                      ),
                                    ],
                            ),
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                          );
                        }),
                  );
                }),
            AnimatedBuilder(
              animation: mainDrawerController,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(
                      (MediaQuery.of(context).size.width *
                              (1 - mainDrawerController.value)) *
                          _kMap[widget.direction]!,
                      0),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isOpened,
                      builder: (_, _isOpened, ___) {
                        return Container(
                          decoration: BoxDecoration(
                            color: widget.style.mainColor,
                            boxShadow: !_isOpened
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(2, 2),
                                      spreadRadius: 3.0,
                                      blurRadius: 6.0,
                                    ),
                                  ],
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: Padding(
                            padding: widget.direction ==
                                    DrawerDirection.fromLeftToRight
                                ? EdgeInsets.only(
                                    left: _kPadding,
                                  )
                                : EdgeInsets.only(
                                    right: _kPadding,
                                  ),
                            child: widget.drawer,
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiningDrawerController {
  _LiningDrawerState? _state;

  /// return the drawer opening state
  bool get isDrawerOpen => _state!.isOpened.value;

  /// open the drawer
  void open() => _state!._firstShadowController.forward();

  /// close the drawer
  void close() => _state!.mainDrawerController.reverse();

  /// open/close the drawer auto
  void toggleDrawer() => _state!.isOpened.value ? close() : open();
}

class LiningDrawerStyle {
  /// bottom container color
  final Color bottomColor;

  /// middle container color
  final Color middleColor;

  /// main container color
  final Color mainColor;

  /// bottom container open ratio
  final double bottomOpenRatio;

  /// middle container open ratio
  final double middleOpenRatio;

  /// main container open ratio
  final double mainOpenratio;

  const LiningDrawerStyle({
    this.bottomColor = const Color(0xFF3a3b3c),
    this.middleColor = Colors.red,
    this.mainColor = Colors.white,
    this.bottomOpenRatio = 1.0,
    this.middleOpenRatio = 0.90,
    this.mainOpenratio = 0.82,
  });
}
