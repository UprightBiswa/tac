import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';

/// Static illustrated map. No maps SDK and no network until a provider is chosen.
///
/// [showRoute] draws pickup → drop-off. [carProgress] (0–1) moves a car along it.
class MapPreview extends StatelessWidget {
  const MapPreview({super.key, this.height = 180, this.showRoute = false, this.carProgress, this.label});

  final double height;
  final bool showRoute;
  final double? carProgress;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label == null ? 'Map illustration' : 'Map illustration near $label',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapPainter(showRoute: showRoute || carProgress != null, carProgress: carProgress),
                ),
              ),
              if (label != null)
                Positioned(
                  left: AppSizes.s12,
                  top: AppSizes.s12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                        Gap.w4,
                        Text(label!, style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.showRoute, this.carProgress});

  final bool showRoute;
  final double? carProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.mapLand);

    final water = Path()
      ..moveTo(w * 0.66, 0)
      ..quadraticBezierTo(w * 0.56, h * 0.45, w, h * 0.72)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(water, Paint()..color = AppColors.mapWater);

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(Offset(0, h * 0.55), Offset(w * 0.7, h * 0.48), road)
      ..drawLine(Offset(w * 0.28, 0), Offset(w * 0.36, h), road)
      ..drawLine(Offset(w * 0.05, h * 0.15), Offset(w * 0.6, h * 0.95), road..strokeWidth = 4);

    if (!showRoute) {
      final c = Offset(w * 0.34, h * 0.52);
      canvas
        ..drawCircle(c, 24, Paint()..color = AppColors.primary.withValues(alpha: 0.18))
        ..drawCircle(c, 10, Paint()..color = AppColors.primary)
        ..drawCircle(
          c,
          10,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      return;
    }

    final route = Path()
      ..moveTo(w * 0.14, h * 0.8)
      ..cubicTo(w * 0.34, h * 0.25, w * 0.6, h * 0.95, w * 0.84, h * 0.26);
    canvas.drawPath(
      route,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _pin(canvas, Offset(w * 0.14, h * 0.8), AppColors.navy);
    _pin(canvas, Offset(w * 0.84, h * 0.26), AppColors.primary);

    final progress = carProgress;
    if (progress != null) {
      final metric = route.computeMetrics().first;
      final pos = metric.getTangentForOffset(metric.length * progress.clamp(0, 1))!.position;
      canvas
        ..drawCircle(pos, 13, Paint()..color = Colors.white)
        ..drawCircle(pos, 10, Paint()..color = AppColors.navy);
    }
  }

  void _pin(Canvas canvas, Offset at, Color color) {
    canvas
      ..drawCircle(at, 9, Paint()..color = Colors.white)
      ..drawCircle(at, 6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.showRoute != showRoute || old.carProgress != carProgress;
}
