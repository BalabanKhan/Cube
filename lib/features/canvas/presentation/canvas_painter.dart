import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ShaderBackgroundPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;

  ShaderBackgroundPainter({required this.shader, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    // Base color: light dirty canvas
    shader.setFloat(3, 0.95);
    shader.setFloat(4, 0.92);
    shader.setFloat(5, 0.88);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant ShaderBackgroundPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}

Path applyBrutalistJitter(Path originalPath, double intensity, double frequency) {
  final jittered = Path();
  for (final metric in originalPath.computeMetrics()) {
    if (metric.length == 0) continue;
    
    bool isFirst = true;
    double distance = 0.0;
    const double step = 6.0; // sample points every 6 pixels
    
    while (distance <= metric.length) {
      final tangent = metric.getTangentForOffset(distance);
      if (tangent != null) {
        final pos = tangent.position;
        final vector = tangent.vector;
        
        // Perpendicular vector
        final perpX = -vector.dy;
        final perpY = vector.dx;
        
        // Procedural wave using sine wave combinations
        final noiseVal = math.sin(distance * frequency) * math.cos(distance * frequency * 2.3);
        final displacement = noiseVal * intensity;
        
        final newX = pos.dx + perpX * displacement;
        final newY = pos.dy + perpY * displacement;
        
        if (isFirst) {
          jittered.moveTo(newX, newY);
          isFirst = false;
        } else {
          jittered.lineTo(newX, newY);
        }
      }
      distance += step;
    }
    if (metric.isClosed) {
      jittered.close();
    }
  }
  return jittered;
}

class CubismElement {
  final Path path;
  final Color color;
  final Offset offset;
  final double rotation;
  final double scale;
  double progress; // 0.0 to 1.0
  final bool isFilled;
  
  // Cache the path metrics to avoid computeMetrics in paint()
  late final List<ui.PathMetric> cachedMetrics;

  CubismElement({
    required Path path,
    required this.color,
    required this.offset,
    required this.rotation,
    required this.scale,
    this.progress = 0.0,
    required this.isFilled,
    bool applyJitter = true,
  }) : path = applyJitter ? applyBrutalistJitter(path, 1.5, 0.12) : path {
    cachedMetrics = this.path.computeMetrics().toList();
  }
}

class CubismPainter extends CustomPainter {
  final List<CubismElement> elements;
  final ui.Image? bakedImage;

  CubismPainter(this.elements, {this.bakedImage});

  @override
  void paint(Canvas canvas, Size size) {
    if (bakedImage != null) {
      canvas.drawImage(bakedImage!, Offset.zero, Paint());
    }

    for (var element in elements) {
      canvas.save();
      canvas.translate(element.offset.dx, element.offset.dy);
      canvas.rotate(element.rotation);
      canvas.scale(element.scale);

      // Çizim ve doldurma aşamalarını ayırıyoruz:
      // %0 - %80 arası sadece fırça darbeleriyle dış hat çizilir.
      // %80 - %100 arası iç dolgu (fırça darbesi efektiyle) belirir.
      final double strokeProgress = (element.progress / 0.8).clamp(0.0, 1.0);
      final double fillProgress = ((element.progress - 0.8) / 0.2).clamp(0.0, 1.0);

      final animatedPath = Path();
      for (var metric in element.cachedMetrics) {
        animatedPath.addPath(metric.extractPath(0, metric.length * strokeProgress), Offset.zero);
      }

      // Vahşi Fırça Darbeleri (Brutalist Brush Strokes)
      final int bristles = 6; 
      for (int i = 0; i < bristles; i++) {
        // Kıllar arası asimetrik kayma
        final double jitterX = (i - bristles / 2.0) * 1.8;
        final double jitterY = ((i % 2 == 0) ? 1.2 : -1.2) * 1.5;
        
        // Boyanın şeffaflığı uçlara doğru azalır
        final double alphaMultiplier = (i == 0 || i == bristles - 1) ? 0.3 : 0.6;
        
        final bristlePaint = Paint()
          ..color = element.color.withValues(alpha: strokeProgress * alphaMultiplier)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 + (i % 3) * 0.8
          ..strokeJoin = StrokeJoin.bevel
          ..strokeCap = StrokeCap.square
          ..blendMode = BlendMode.multiply;
          
        canvas.save();
        canvas.translate(jitterX, jitterY);
        // Fırça izini bırakıyoruz
        canvas.drawPath(animatedPath, bristlePaint);
        canvas.restore();
      }

      // Dolgu aşaması: Çizim bittikten sonra fırça darbesi gibi belirir
      if (element.isFilled && fillProgress > 0.0) {
        // Dolguyu da sert ve katmanlı bir fırça lekesi gibi göstermek için 
        // 3 farklı katman halinde hafif kaydırarak çiziyoruz.
        for (int i = 0; i < 3; i++) {
          final double fillJitterX = (i - 1) * 3.0;
          final double fillJitterY = (i - 1) * -2.5;
          
          final fillPaint = Paint()
            ..color = element.color.withValues(alpha: fillProgress * 0.25)
            ..style = PaintingStyle.fill
            ..blendMode = BlendMode.multiply;
            
          canvas.save();
          canvas.translate(fillJitterX, fillJitterY);
          // Dolguda yarım kalan path (animatedPath) yerine tam path kullanıyoruz
          canvas.drawPath(element.path, fillPaint);
          canvas.restore();
        }
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CubismPainter oldDelegate) => true;
}

// CubismPaths moved to cubism_paths.dart
