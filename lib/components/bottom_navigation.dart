import 'package:flutter/material.dart';

class BottomNavigationDotBar extends StatefulWidget {
  final List<BottomNavigationDotBarItem> items;
  final Color? activeColor;
  final Color? color;
  final int? counter;

  const BottomNavigationDotBar(
      {required this.items, this.activeColor, this.color, this.counter, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationDotBarState();
}

class _BottomNavigationDotBarState extends State<BottomNavigationDotBar> {
  GlobalKey _keyBottomBar = GlobalKey();
  late double _numPositionBase = 0, _numDifferenceBase = 0, _positionLeftIndicatorDot = 0;
  int _indexPageSelected = 0;
  late Color _color = Colors.black45, _activeColor = Theme.of(context).primaryColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _color = widget.color ?? Colors.black45;
    _activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final sizeBottomBar =
        (_keyBottomBar.currentContext!.findRenderObject() as RenderBox).size;
    _numPositionBase = ((sizeBottomBar.width / widget.items.length));
    _numDifferenceBase = (_numPositionBase - (_numPositionBase / 2) + 2);
    setState(() {
      _positionLeftIndicatorDot = _numPositionBase - _numDifferenceBase;
    });
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFfcfafa),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 8,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Stack(
            key: _keyBottomBar,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        _createNavigationIconButtonList(widget.items.asMap())),
              ),
              AnimatedPositioned(
                  child:
                      CircleAvatar(radius: 2.5, backgroundColor: _activeColor),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  left: _positionLeftIndicatorDot,
                  bottom: 0),
            ],
          ),
        ),
      );

  List<_NavigationIconButton> _createNavigationIconButtonList(
      Map<int, BottomNavigationDotBarItem> mapItem) {
    List<_NavigationIconButton> children = [];
    mapItem.forEach((index, item) => children.add(_NavigationIconButton(
            item.icon,
            item.title ?? "",
            (index == _indexPageSelected) ? _activeColor : _color,
            item.onTap, () {
              _changeOptionBottomBar(index);
            },
            item.counter
        )
    ));
    return children;
  }

  void _changeOptionBottomBar(int indexPageSelected) {
    if (indexPageSelected != _indexPageSelected) {
      setState(() {
        _positionLeftIndicatorDot =
            (_numPositionBase * (indexPageSelected + 1)) - _numDifferenceBase;
      });
      _indexPageSelected = indexPageSelected;
    }
  }
}

class BottomNavigationDotBarItem {
  final IconData icon;
  final NavigationIconButtonTapCallback onTap;
  final String? title;
  final int? counter;

  const BottomNavigationDotBarItem(
      {required this.icon, required this.onTap, this.title, this.counter});
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {
  final IconData _icon;
  final Color _colorIcon;
  final NavigationIconButtonTapCallback _onTapInternalButton;
  final NavigationIconButtonTapCallback _onTapExternalButton;
  final String _title;
  final int? _counter;

  const _NavigationIconButton(this._icon, this._title, this._colorIcon,
      this._onTapInternalButton, this._onTapExternalButton, this._counter,
      {Key? key})
      : super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _opacityIcon = 1;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.93).animate(_controller);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        setState(() {
          _opacityIcon = 0.7;
        });
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() {
          _opacityIcon = 1;
        });
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() {
          _opacityIcon = 1;
        });
      },
      onTap: () {
        widget._onTapInternalButton();
        widget._onTapExternalButton();
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 2)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
        child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedOpacity(
                opacity: _opacityIcon,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Icon(widget._icon, color: widget._colorIcon),
                        widget._counter != null ? Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 13,
                              minHeight: 13,
                            ),
                            child: Text(
                              '${widget._counter}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ) : const SizedBox(width: 0,height: 0,)
                      ],
                    ),
                    Text(
                      widget._title,
                      style: TextStyle(
                        color: widget._colorIcon,
                      ),
                    )
                  ],
                ))),
      ));
}
