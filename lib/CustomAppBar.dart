import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _kLeadingWidth = kToolbarHeight;
const Object _kDefaultHeroTag = const Object();

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading: true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation: 4.0,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.textTheme,
    this.primary: true,
    this.centerTitle,
    this.titleSpacing: NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity: 1.0,
    this.bottomOpacity: 1.0,
    this.heroTag: _kDefaultHeroTag,
  })  : assert(automaticallyImplyLeading != null),
        assert(elevation != null),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(toolbarOpacity != null),
        assert(bottomOpacity != null),
        preferredSize = new Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  final Object heroTag;

  final Widget leading;

  final bool automaticallyImplyLeading;

  final Widget title;

  final List<Widget> actions;

  final Widget flexibleSpace;

  final PreferredSizeWidget bottom;

  final double elevation;

  final Color backgroundColor;

  final Brightness brightness;

  final IconThemeData iconTheme;

  final TextTheme textTheme;

  final bool primary;

  final bool centerTitle;

  final double titleSpacing;

  final double toolbarOpacity;

  final double bottomOpacity;

  @override
  final Size preferredSize;

  bool _getEffectiveCenterTitle(ThemeData themeData) {
    if (centerTitle != null) return centerTitle;
    assert(themeData.platform != null);
    switch (themeData.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return false;
      case TargetPlatform.iOS:
        return actions == null || actions.length < 2;
    }
    return null;
  }

  @override
  _CustomAppBarState createState() => new _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  void _handleDrawerButton() {
    Scaffold.of(context).openDrawer();
  }

  void _handleDrawerButtonEnd() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    final ThemeData themeData = Theme.of(context);
    final ScaffoldState scaffold = Scaffold.of(context, nullOk: true);
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    IconThemeData appBarIconTheme = widget.iconTheme ?? themeData.primaryIconTheme;
    TextStyle centerStyle = widget.textTheme?.title ?? themeData.primaryTextTheme.title;
    TextStyle sideStyle = widget.textTheme?.body1 ?? themeData.primaryTextTheme.body1;

    final Brightness brightness = widget.brightness ?? themeData.primaryColorBrightness;
    SystemChrome.setSystemUIOverlayStyle(brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

    if (widget.toolbarOpacity != 1.0) {
      final double opacity = const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.toolbarOpacity);
      if (centerStyle?.color != null) centerStyle = centerStyle.copyWith(color: centerStyle.color.withOpacity(opacity));
      if (sideStyle?.color != null) sideStyle = sideStyle.copyWith(color: sideStyle.color.withOpacity(opacity));
      appBarIconTheme = appBarIconTheme.copyWith(opacity: opacity * (appBarIconTheme.opacity ?? 1.0));
    }

    Widget leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = new IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _handleDrawerButton,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (canPop) leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      leading = new ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: _kLeadingWidth),
        child: leading,
      );
    }

    Widget title = widget.title;
    if (title != null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          title = new Semantics(namesRoute: true, child: title);
          break;
        case TargetPlatform.iOS:
          break;
      }

      title = new DefaultTextStyle(
        style: centerStyle,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
    }

    Widget actions;
    if (widget.actions != null && widget.actions.isNotEmpty) {
      actions = new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions,
      );
    } else if (hasEndDrawer) {
      actions = new IconButton(
        icon: const Icon(Icons.menu),
        onPressed: _handleDrawerButtonEnd,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }

    final Widget toolbar = new Padding(
      padding: const EdgeInsetsDirectional.only(end: 4.0),
      child: new NavigationToolbar(
        leading: leading,
        middle: title,
        trailing: actions,
        centerMiddle: widget._getEffectiveCenterTitle(themeData),
        middleSpacing: widget.titleSpacing,
      ),
    );

    Widget appBar = new ClipRect(
      child: new CustomSingleChildLayout(
        delegate: const _ToolbarContainerLayout(),
        child: IconTheme.merge(
          data: appBarIconTheme,
          child: new DefaultTextStyle(
            style: sideStyle,
            child: toolbar,
          ),
        ),
      ),
    );

    if (widget.bottom != null) {
      appBar = new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Flexible(
            child: new ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: kToolbarHeight),
              child: appBar,
            ),
          ),
          widget.bottomOpacity == 1.0
              ? widget.bottom
              : new Opacity(
                  opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
                  child: widget.bottom,
                ),
        ],
      );
    }

    if (widget.primary) {
      appBar = new SafeArea(
        top: true,
        child: appBar,
      );
    }

    appBar = new Align(
      alignment: Alignment.topCenter,
      child: appBar,
    );

    if (widget.flexibleSpace != null) {
      appBar = new Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          widget.flexibleSpace,
          appBar,
        ],
      );
    }

    Widget child = new Material(
      color: widget.backgroundColor ?? themeData.primaryColor,
      elevation: widget.elevation,
      child: appBar,
    );

    if (widget.heroTag != null) {
      return new Hero(
        tag: widget.heroTag,
        child: child,
      );
    }

    return child;
  }
}

class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout();

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: kToolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return new Size(constraints.maxWidth, kToolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => false;
}
