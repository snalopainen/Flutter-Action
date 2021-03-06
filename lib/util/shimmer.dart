import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;

  @override
  _ShimmerState createState() => new _ShimmerState();

  Shimmer({
    Key key,
    @required this.child,
    @required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
  }) : super(key: key);

  Shimmer.fromColors(
      {Key key,
      @required this.child,
      @required Color baseColor,
      @required Color highlightColor,
      this.period = const Duration(milliseconds: 1500),
      this.direction = ShimmerDirection.ltr,
      this.loop = 0})
      : gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: [
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]),
        super(key: key);
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {})
      ..forward();////启动动画(正向执行)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }
}

/*
我们的View继承于SingleChildRenderObjectWidget会默认实现一个createRenderObject方法
会返回一个RenderConstrainedBox
这个对象就是负责对你Widget的绘制和布局。
 */
class _Shimmer extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return null;
  }

  @override
  SingleChildRenderObjectElement createElement() {
    // TODO: implement createElement
    return super.createElement();
  }
}

enum ShimmerDirection { ltr, rtl, ttb, btt }

class _ShimmerBox extends RenderProxyBox {
  final _clearPaint = Paint();
  final Paint _gradientPaint;
  final Gradient _gradient;
  final ShimmerDirection _direction;
  double _percent;
  Rect _rect;

  _ShimmerBox(this._percent, this._direction, this._gradient)
      : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue != _percent) {
      _percent = newValue;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final width = child.size.width;
    final height = child.size.height;
    Rect rect;
    double dx, dy;
    dx = _offset(-width, width, _percent);
    dy = 0.0;
    rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
    if (_rect != rect) {
      _gradientPaint.shader = _gradient.createShader(rect);
      _rect = rect;
    }
    context.canvas.saveLayer(offset & child.size, _clearPaint);
    context.paintChild(child, offset);
    context.canvas.translate(dx, dy);
    context.canvas.drawRect(rect, _gradientPaint);
    context.canvas.restore();
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
