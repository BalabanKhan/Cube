import 'dart:math';
import 'package:flutter/material.dart';
import 'canvas_painter.dart';

class CubismPalette {
  final List<Color> colors;
  CubismPalette(this.colors);

  Color getRandomColor(Random rnd) => colors[rnd.nextInt(colors.length)];
}

class CubismPalettes {
  static final picasso = CubismPalette([
    const Color(0xFFE4A025), // Mustard Yellow
    const Color(0xFF2E7A3C), // Forest Green
    const Color(0xFF4A3B32), // Chocolate Brown
    const Color(0xFF8A6C9B), // Muted Purple
    const Color(0xFF8C1C13), // Murder Red
    const Color(0xFF1E1E1E), // Charcoal Black
    const Color(0xFFF5F5F5), // Clinical White
  ]);

  static final guernica = CubismPalette([
    const Color(0xFF708090), // Slate Grey
    const Color(0xFFFFFFF0), // Ivory
    const Color(0xFF000000), // Black
    const Color(0xFF36454F), // Charcoal
    const Color(0xFFD3D3D3), // Light Grey
  ]);

  static final mediterranean = CubismPalette([
    const Color(0xFFE2725B), // Terracotta
    const Color(0xFF0047AB), // Cobalt Blue
    const Color(0xFF808000), // Olive
    const Color(0xFFC2B280), // Sand
    const Color(0xFFE6E6FA), // Lavender
  ]);

  static final List<CubismPalette> all = [picasso, guernica, mediterranean];

  static CubismPalette getRandomPalette(Random rnd) => all[rnd.nextInt(all.length)];
}

class CompositionLayerRule {
  final List<int> pathIndices;
  final double minX, maxX;
  final double minY, maxY;
  final double minScale, maxScale;
  final double minRotation, maxRotation;
  final bool isFilled;

  CompositionLayerRule({
    required this.pathIndices,
    required this.minX, required this.maxX,
    required this.minY, required this.maxY,
    required this.minScale, required this.maxScale,
    required this.minRotation, required this.maxRotation,
    required this.isFilled,
  });
}

class CompositionTemplate {
  final List<CompositionLayerRule> layers;
  final List<Offset> focalPoints; // Added for intentional blueprint structure

  CompositionTemplate(this.layers, {this.focalPoints = const []});


  CompositionLayerRule getRuleForIndex(int elementIndex, int totalElements) {
    // Map elementIndex to a layer proportionately
    double progress = elementIndex / totalElements;
    int layerIndex = (progress * layers.length).floor();
    if (layerIndex >= layers.length) layerIndex = layers.length - 1;
    return layers[layerIndex];
  }
}

class CubismTemplates {
  static final portraitTemplate = CompositionTemplate([
    // Layer 1: Background Layout (Large, filled shapes)
    CompositionLayerRule(
      pathIndices: List.generate(18, (i) => i + 3), // Paths 3-20
      minX: 0.1, maxX: 0.9, minY: 0.1, maxY: 0.9,
      minScale: 1.5, maxScale: 3.0,
      minRotation: 0, maxRotation: pi,
      isFilled: true,
    ),
    // Layer 2: Head & Hair Outlines (Centered, large)
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 21), // Paths 21-40
      minX: 0.3, maxX: 0.7, minY: 0.2, maxY: 0.6,
      minScale: 1.0, maxScale: 2.0,
      minRotation: -pi/4, maxRotation: pi/4,
      isFilled: false,
    ),
    // Layer 3: Face Profile Partition
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 41), // Paths 41-60
      minX: 0.4, maxX: 0.6, minY: 0.2, maxY: 0.7,
      minScale: 1.0, maxScale: 1.5,
      minRotation: -pi/8, maxRotation: pi/8,
      isFilled: true,
    ),
    // Layer 4: Facial Features (Eyes, lips, small blocks)
    CompositionLayerRule(
      pathIndices: [0, 1, 2], // Handcrafted eye, lips, block
      minX: 0.4, maxX: 0.6, minY: 0.3, maxY: 0.5,
      minScale: 0.5, maxScale: 1.0,
      minRotation: -pi/6, maxRotation: pi/6,
      isFilled: false,
    ),
    // Layer 5: Torso & Clothing (Bottom half)
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 61), // Paths 61-80
      minX: 0.2, maxX: 0.8, minY: 0.6, maxY: 0.9,
      minScale: 1.2, maxScale: 2.2,
      minRotation: -pi/3, maxRotation: pi/3,
      isFilled: true,
    ),
    // Layer 6: Hat & Details (Top half, small)
    CompositionLayerRule(
      pathIndices: List.generate(19, (i) => i + 81), // Paths 81-99
      minX: 0.3, maxX: 0.7, minY: 0.1, maxY: 0.3,
      minScale: 0.5, maxScale: 1.2,
      minRotation: -pi, maxRotation: pi,
      isFilled: true,
    ),
  ], focalPoints: [const Offset(0.5, 0.4)]); // Focus on the face/eyes

  static final stillLifeTemplate = CompositionTemplate([
    // Background walls
    CompositionLayerRule(
      pathIndices: List.generate(18, (i) => i + 3), 
      minX: 0.0, maxX: 1.0, minY: 0.0, maxY: 0.6,
      minScale: 1.5, maxScale: 3.5,
      minRotation: -pi/4, maxRotation: pi/4,
      isFilled: true,
    ),
    // Table (Bottom half)
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 21), 
      minX: 0.1, maxX: 0.9, minY: 0.5, maxY: 0.9,
      minScale: 1.2, maxScale: 2.5,
      minRotation: -pi/12, maxRotation: pi/12,
      isFilled: true,
    ),
    // Guitar/Instrument body
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 41), 
      minX: 0.3, maxX: 0.7, minY: 0.3, maxY: 0.7,
      minScale: 1.0, maxScale: 1.8,
      minRotation: -pi/6, maxRotation: pi/3,
      isFilled: true,
    ),
    // Instrument strings/neck
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 61), 
      minX: 0.4, maxX: 0.6, minY: 0.2, maxY: 0.6,
      minScale: 0.8, maxScale: 1.5,
      minRotation: -pi/6, maxRotation: pi/6,
      isFilled: false,
    ),
    // Fruits & Cups (scattered on table)
    CompositionLayerRule(
      pathIndices: List.generate(19, (i) => i + 81), 
      minX: 0.2, maxX: 0.8, minY: 0.6, maxY: 0.8,
      minScale: 0.4, maxScale: 0.9,
      minRotation: -pi, maxRotation: pi,
      isFilled: true,
    ),
  ], focalPoints: [const Offset(0.5, 0.65)]); // Focus on the table cluster

  static final landscapeTemplate = CompositionTemplate([
    // Sky
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 3), 
      minX: 0.0, maxX: 1.0, minY: 0.0, maxY: 0.4,
      minScale: 1.5, maxScale: 3.0,
      minRotation: -pi/16, maxRotation: pi/16,
      isFilled: true,
    ),
    // Sun / Moon / Celestial bodies
    CompositionLayerRule(
      pathIndices: List.generate(10, (i) => i + 23), 
      minX: 0.5, maxX: 0.9, minY: 0.1, maxY: 0.3,
      minScale: 0.8, maxScale: 1.5,
      minRotation: 0, maxRotation: 2 * pi,
      isFilled: true,
    ),
    // Distant Mountains
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 41), 
      minX: 0.0, maxX: 1.0, minY: 0.3, maxY: 0.6,
      minScale: 1.2, maxScale: 2.2,
      minRotation: -pi/8, maxRotation: pi/8,
      isFilled: true,
    ),
    // Foreground Hills / Architecture
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 61), 
      minX: 0.0, maxX: 1.0, minY: 0.5, maxY: 0.9,
      minScale: 1.5, maxScale: 2.8,
      minRotation: -pi/12, maxRotation: pi/12,
      isFilled: true,
    ),
    // Details (Trees, geometric foliage)
    CompositionLayerRule(
      pathIndices: List.generate(19, (i) => i + 81), 
      minX: 0.1, maxX: 0.9, minY: 0.6, maxY: 0.9,
      minScale: 0.5, maxScale: 1.2,
      minRotation: -pi/4, maxRotation: pi/4,
      isFilled: false,
    ),
  ], focalPoints: [const Offset(0.7, 0.2)]); // Focus on the celestial body (sun/moon)

  static final collageTemplate = CompositionTemplate([
    // Background Newspaper / Paper Clippings
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 3), 
      minX: 0.1, maxX: 0.9, minY: 0.1, maxY: 0.9,
      minScale: 1.5, maxScale: 2.8,
      minRotation: -pi/16, maxRotation: pi/16, // Mostly strict horizontal/vertical grid
      isFilled: true,
    ),
    // Matchbox / Wine Labels (Denser, smaller blocks)
    CompositionLayerRule(
      pathIndices: List.generate(15, (i) => i + 23), 
      minX: 0.2, maxX: 0.8, minY: 0.2, maxY: 0.8,
      minScale: 0.8, maxScale: 1.5,
      minRotation: -pi/8, maxRotation: pi/8,
      isFilled: true,
    ),
    // Typography fragments (JOU, BAL) - Emulated with sharp geometric lines
    CompositionLayerRule(
      pathIndices: List.generate(10, (i) => i + 40), 
      minX: 0.3, maxX: 0.7, minY: 0.3, maxY: 0.7,
      minScale: 0.4, maxScale: 0.9,
      minRotation: -pi/4, maxRotation: pi/4,
      isFilled: false, // Just sharp contours acting as letters
    ),
    // Surface texture lines
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 51), 
      minX: 0.1, maxX: 0.9, minY: 0.1, maxY: 0.9,
      minScale: 1.0, maxScale: 2.0,
      minRotation: 0, maxRotation: pi,
      isFilled: false,
    ),
  ], focalPoints: [const Offset(0.4, 0.4), const Offset(0.7, 0.7)]); // Multiple asymmetric focal points

  static final interiorSpaceTemplate = CompositionTemplate([
    // Reversed Perspective Walls & Ceilings
    CompositionLayerRule(
      pathIndices: List.generate(15, (i) => i + 60), 
      minX: 0.0, maxX: 1.0, minY: 0.0, maxY: 1.0,
      minScale: 2.0, maxScale: 4.0,
      minRotation: -pi/6, maxRotation: pi/6,
      isFilled: true,
    ),
    // Window / Fireplace center
    CompositionLayerRule(
      pathIndices: List.generate(10, (i) => i + 3), 
      minX: 0.3, maxX: 0.7, minY: 0.3, maxY: 0.7,
      minScale: 1.0, maxScale: 2.0,
      minRotation: 0, maxRotation: 0, // Strict right angles
      isFilled: true,
    ),
    // Chair Cane Texture (Right side)
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 80), 
      minX: 0.6, maxX: 0.9, minY: 0.4, maxY: 0.9,
      minScale: 0.3, maxScale: 0.7,
      minRotation: -pi/12, maxRotation: pi/12,
      isFilled: false,
    ),
    // Staircase (Left side climbing)
    CompositionLayerRule(
      pathIndices: List.generate(15, (i) => i + 18), 
      minX: 0.0, maxX: 0.3, minY: 0.5, maxY: 1.0,
      minScale: 0.8, maxScale: 1.5,
      minRotation: -pi/8, maxRotation: pi/8,
      isFilled: true,
    ),
  ], focalPoints: [const Offset(0.5, 0.5)]); // Center perspective focus

  static final industrialTemplate = CompositionTemplate([
    // Factory Chimneys (Vertical axes)
    CompositionLayerRule(
      pathIndices: List.generate(15, (i) => i + 30), 
      minX: 0.1, maxX: 0.9, minY: 0.0, maxY: 1.0,
      minScale: 1.5, maxScale: 3.5,
      minRotation: -pi/32, maxRotation: pi/32, // Strictly vertical
      isFilled: true,
    ),
    // Bridges and Beams (Horizontal & Diagonal axes)
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 45), 
      minX: 0.0, maxX: 1.0, minY: 0.3, maxY: 0.8,
      minScale: 1.5, maxScale: 3.0,
      minRotation: pi/4, maxRotation: pi/2,
      isFilled: true,
    ),
    // Gears and Wheels (Circular forms)
    CompositionLayerRule(
      pathIndices: [4, 5, 10, 11, 16, 17, 23, 24, 35, 36, 44, 45, 48, 49, 72, 73], // Arcs
      minX: 0.2, maxX: 0.8, minY: 0.2, maxY: 0.8,
      minScale: 0.8, maxScale: 1.6,
      minRotation: 0, maxRotation: 2 * pi, // Spinning chaotic rotation
      isFilled: false, // Sharp metal gear outlines
    ),
    // Geometric Smoke Clouds
    CompositionLayerRule(
      pathIndices: List.generate(20, (i) => i + 65), 
      minX: 0.4, maxX: 1.0, minY: 0.0, maxY: 0.4,
      minScale: 1.0, maxScale: 2.5,
      minRotation: -pi/4, maxRotation: pi/4,
      isFilled: true,
    ),
  ], focalPoints: [const Offset(0.5, 0.5)]); // Chaotic center focus

  static final List<CompositionTemplate> all = [
    portraitTemplate, 
    stillLifeTemplate, 
    landscapeTemplate,
    collageTemplate,
    interiorSpaceTemplate,
    industrialTemplate
  ];

  static CompositionTemplate getRandomTemplate(Random rnd) => all[rnd.nextInt(all.length)];
}

class CompositionGenerator {
  static Path _simplifyPath(Path originalPath, {double stepLength = 15.0}) {
    final simplified = Path();
    for (final metric in originalPath.computeMetrics()) {
      if (metric.length == 0) continue;
      
      final tangent0 = metric.getTangentForOffset(0.0);
      if (tangent0 != null) {
        simplified.moveTo(tangent0.position.dx, tangent0.position.dy);
      }
      
      double distance = stepLength;
      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          simplified.lineTo(tangent.position.dx, tangent.position.dy);
        }
        distance += stepLength;
      }
      
      final tangentEnd = metric.getTangentForOffset(metric.length);
      if (tangentEnd != null) {
        simplified.lineTo(tangentEnd.position.dx, tangentEnd.position.dy);
      }
      
      if (metric.isClosed) {
        simplified.close();
      }
    }
    return simplified;
  }

  static Path _getGlobalPath(Path localPath, Offset offset, double rotation, double scale) {
    final Matrix4 matrix = Matrix4.identity()
      ..setTranslationRaw(offset.dx, offset.dy, 0.0)
      ..rotateZ(rotation);
    matrix.multiply(Matrix4.diagonal3Values(scale, scale, 1.0));
    return localPath.transform(matrix.storage);
  }

  static Color _blendColors(Color c1, Color c2) {
    return Color.fromARGB(
      255,
      (((c1.r * 255.0) + (c2.r * 255.0)) / 2.0).round().clamp(0, 255),
      (((c1.g * 255.0) + (c2.g * 255.0)) / 2.0).round().clamp(0, 255),
      (((c1.b * 255.0) + (c2.b * 255.0)) / 2.0).round().clamp(0, 255),
    );
  }

  static Path _createBlueprintLine(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);
    return path;
  }

  static List<CubismElement> generatePlannedComposition(
    Size canvasSize, 
    int durationMinutes, 
    List<Path> loadedPaths
  ) {
    final int totalElements = (2.0 * durationMinutes + 10).round();
    final List<CubismElement> plannedElements = [];
    final random = Random();
    
    final palette = CubismPalettes.getRandomPalette(random); 
    final template = CubismTemplates.getRandomTemplate(random); 

    // 1. Calculate Absolute Focal Points
    final absoluteFocalPoints = template.focalPoints
        .map((f) => Offset(f.dx * canvasSize.width, f.dy * canvasSize.height))
        .toList();

    // 2. Blueprint / Kılavuz Çizgileri Çizimi
    // "Kafasında kurup çiziyor" hissi için odak noktalarından geçen inşa çizgileri atıyoruz.
    if (absoluteFocalPoints.isNotEmpty) {
      for (final focal in absoluteFocalPoints) {
        // Çapraz, yatay veya dikey ince çizgiler
        for (int i = 0; i < 3; i++) {
          final angle = random.nextDouble() * pi;
          final length = canvasSize.width * 2.0; // ekrandan taşacak kadar uzun
          final p1 = Offset(focal.dx + cos(angle) * length, focal.dy + sin(angle) * length);
          final p2 = Offset(focal.dx - cos(angle) * length, focal.dy - sin(angle) * length);
          
          plannedElements.add(
            CubismElement(
              path: _createBlueprintLine(p1, p2),
              color: const Color(0xFF1E1E1E).withValues(alpha: 0.15), // Çok soluk siyah/gri kılavuz
              offset: Offset.zero,
              rotation: 0.0,
              scale: 1.0,
              isFilled: false,
              applyJitter: false, // Ince teknik taslak çizgileri titremez, dümdüz çekilir
            ),
          );
        }
      }
    } 

    for (int i = 0; i < totalElements; i++) {
      final rule = template.getRuleForIndex(i, totalElements);
      double progress = i / totalElements;
      
      final pathIndex = rule.pathIndices[random.nextInt(rule.pathIndices.length)];
      var path = loadedPaths[pathIndex % loadedPaths.length];

      // Açısal Basitleştirme (Angular Simplification)
      // %30 ihtimalle yolları basitleştirip keskin köşeli brutalist hale getirelim.
      if (random.nextDouble() < 0.3) {
        path = _simplifyPath(path, stepLength: 12.0 + random.nextDouble() * 18.0);
      }

      final Rect bounds = path.getBounds();
      double scale = rule.minScale + random.nextDouble() * (rule.maxScale - rule.minScale);
      
      // ALGORITHMIC DEPTH: Elements shrink drastically towards the end of the session
      double depthMultiplier = 1.5 - (progress * 1.35); // 1.5 at start, 0.15 at end
      scale = scale * depthMultiplier;

      final rotation = rule.minRotation + random.nextDouble() * (rule.maxRotation - rule.minRotation);
      
      double safeRadius = sqrt(bounds.width * bounds.width + bounds.height * bounds.height) * scale / 2.0;
      
      // Ekran dışına taşmasını engelle: Eğer eleman ekrandan büyükse küçült
      final minScreenDim = min(canvasSize.width, canvasSize.height);
      if (safeRadius * 2.0 > minScreenDim * 0.9) {
         scale = scale * ((minScreenDim * 0.9) / (safeRadius * 2.0));
         safeRadius = sqrt(bounds.width * bounds.width + bounds.height * bounds.height) * scale / 2.0;
      }

      // 3. Focal Gravity (Odak Çekim Gücü)
      // Formların tamamen rastgele saçılmasını engellemek için odak noktalarına doğru belli bir oranda çekiyoruz.
      double rawDx = (rule.minX + random.nextDouble() * (rule.maxX - rule.minX)) * canvasSize.width;
      double rawDy = (rule.minY + random.nextDouble() * (rule.maxY - rule.minY)) * canvasSize.height;

      if (absoluteFocalPoints.isNotEmpty) {
        // Obje merkeze yakın katmanlardaysa daha çok çekilir, arkaplan katmanları daha az çekilir.
        // max pull 0.65 (%65 oranında focal point'e yaklaşır).
        double pullStrength = random.nextDouble() * 0.65 * (1.0 - progress * 0.5); 
        final focal = absoluteFocalPoints[random.nextInt(absoluteFocalPoints.length)];
        
        rawDx = rawDx * (1.0 - pullStrength) + focal.dx * pullStrength;
        rawDy = rawDy * (1.0 - pullStrength) + focal.dy * pullStrength;
      }

      final safeMinX = safeRadius;
      final safeMaxX = max(safeMinX, canvasSize.width - safeRadius);
      final safeMinY = safeRadius;
      final safeMaxY = max(safeMinY, canvasSize.height - safeRadius);

      final dx = rawDx.clamp(safeMinX, safeMaxX);
      final dy = rawDy.clamp(safeMinY, safeMaxY);
      
      final color = palette.getRandomColor(random);

      plannedElements.add(
        CubismElement(
          path: path,
          color: color,
          offset: Offset(dx, dy),
          rotation: rotation,
          scale: scale,
          isFilled: rule.isFilled,
        ),
      );
    }

    // Kesişim Algılama ve Boyama (Intersection Path Operations)
    // Listeyi dolaşıp kesişen elemanlar arasına ek kübist katmanlar ekleyelim.
    final List<CubismElement> intersections = [];
    for (int i = 0; i < plannedElements.length - 1; i++) {
      final elA = plannedElements[i];
      if (!elA.isFilled) continue;

      final globalPathA = _getGlobalPath(elA.path, elA.offset, elA.rotation, elA.scale);

      for (int j = i + 1; j < min(i + 4, plannedElements.length); j++) { // performans için komşu 3 elemana bakalım
        final elB = plannedElements[j];
        if (!elB.isFilled) continue;

        final globalPathB = _getGlobalPath(elB.path, elB.offset, elB.rotation, elB.scale);

        try {
          final intersectPath = Path.combine(PathOperation.intersect, globalPathA, globalPathB);
          final bounds = intersectPath.getBounds();
          
          // Eğer anlamlı bir kesişim alanı varsa
            if (bounds.width > 20 && bounds.height > 20) {
              intersections.add(
                CubismElement(
                  path: intersectPath,
                  color: _blendColors(elA.color, elB.color).withValues(alpha: 0.8), // hafif saydam ve harmanlanmış renk
                  offset: Offset.zero,
                  rotation: 0.0,
                  scale: 1.0,
                  isFilled: true,
                  applyJitter: false, // Kesişen yollar zaten jitter'lanmış temel yollardan üretildi
                ),
              );
            }
        } catch (e) {
          // Bazı eski Flutter sürümleri veya platformlar combine işlemlerinde hata üretebilir, yoksayalım.
        }
      }
    }

    // Kesişen katmanları normal çizim sıralamasına ekleyelim.
    plannedElements.addAll(intersections);
    
    return plannedElements;
  }
}
