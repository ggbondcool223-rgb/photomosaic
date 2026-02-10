import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

class ImageProcessor {
  static Future<String?> applyFilter(
    String imagePath,
    String filterType,
    double intensity,
  ) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        Logger.e('Failed to decode image');
        return null;
      }

      switch (filterType) {
        case 'grayscale':
          image = img.grayscale(image);
          break;
        case 'sepia':
          image = img.sepia(image);
          break;
        case 'vibrant':
          image = img.adjustColor(image, saturation: 1.0 + intensity);
          break;
        case 'soft':
          image = img.adjustColor(image, saturation: 1.0 - intensity * 0.5);
          break;
      }

      final filteredBytes = img.encodePng(image);
      final directory = await getApplicationDocumentsDirectory();
      final outputPath = '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.png';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(filteredBytes);
      Logger.d('Filter applied: $outputPath');
      return outputPath;
    } catch (e) {
      Logger.e('Failed to apply filter', e);
      return null;
    }
  }

  static Future<String?> combineImages(
    List<String> imagePaths,
    List<Map<String, dynamic>> layout,
  ) async {
    try {
      if (imagePaths.isEmpty) {
        Logger.e('No image paths provided');
        return null;
      }

      if (layout.isEmpty) {
        Logger.e('No layout data provided');
        return null;
      }

      if (imagePaths.length != layout.length) {
        Logger.e('Image count (${imagePaths.length}) does not match layout count (${layout.length})');
        return null;
      }

      final images = <img.Image>[];
      final validLayouts = <Map<String, dynamic>>[];

      for (var i = 0; i < imagePaths.length; i++) {
        final path = imagePaths[i];
        final file = File(path);
        
        if (!await file.exists()) {
          Logger.e('Image file does not exist: $path');
          continue;
        }

        try {
          final bytes = await file.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            images.add(image);
            validLayouts.add(layout[i]);
            Logger.d('Loaded image $i: $path (${image.width}x${image.height})');
          } else {
            Logger.e('Failed to decode image: $path');
          }
        } catch (e) {
          Logger.e('Error processing image $path', e);
        }
      }

      if (images.isEmpty) {
        Logger.e('No valid images to combine');
        return null;
      }

      if (images.length != validLayouts.length) {
        Logger.e('Valid image count (${images.length}) does not match valid layout count (${validLayouts.length})');
        return null;
      }

      Logger.d('Combining ${images.length} images with layout');
      final width = 1000;
      final height = 1000;
      final combined = img.Image(width: width, height: height);
      img.fill(combined, color: img.ColorRgb8(255, 255, 255));

      for (var i = 0; i < images.length && i < validLayouts.length; i++) {
        final slot = validLayouts[i];
        final x = ((slot['x'] as num).toDouble() * width).toInt();
        final y = ((slot['y'] as num).toDouble() * height).toInt();
        final w = ((slot['width'] as num).toDouble() * width).toInt();
        final h = ((slot['height'] as num).toDouble() * height).toInt();

        if (w > 0 && h > 0) {
          try {
            final resized = img.copyResize(images[i], width: w, height: h, interpolation: img.Interpolation.linear);
            img.compositeImage(combined, resized, dstX: x, dstY: y);
            Logger.d('Composited image $i at ($x, $y) with size ${w}x$h');
          } catch (e) {
            Logger.e('Error compositing image $i', e);
          }
        }
      }

      Logger.d('Encoding combined image to PNG');
      final combinedBytes = img.encodePng(combined);
      final directory = await getApplicationDocumentsDirectory();
      final outputPath = '${directory.path}/combined_${DateTime.now().millisecondsSinceEpoch}.png';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(combinedBytes);
      Logger.d('Images combined successfully: $outputPath (${combinedBytes.length} bytes)');
      return outputPath;
    } catch (e, stackTrace) {
      Logger.e('Failed to combine images', e, stackTrace);
      return null;
    }
  }

  static Future<String?> addText(
    String imagePath,
    String text,
    int x,
    int y,
    int fontSize,
    int colorValue,
  ) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        Logger.e('Failed to decode image');
        return null;
      }

      final r = (colorValue >> 16) & 0xFF;
      final g = (colorValue >> 8) & 0xFF;
      final b = colorValue & 0xFF;
      final color = img.ColorRgb8(r, g, b);

      for (var i = 0; i < text.length && x + i * fontSize < image.width; i++) {
        final charX = x + i * fontSize;
        if (charX >= 0 && charX < image.width && y >= 0 && y < image.height) {
          img.fillRect(image, x1: charX, y1: y, x2: charX + fontSize ~/ 2, y2: y + fontSize, color: color);
        }
      }

      final outputBytes = img.encodePng(image);
      final directory = await getApplicationDocumentsDirectory();
      final outputPath = '${directory.path}/text_${DateTime.now().millisecondsSinceEpoch}.png';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(outputBytes);
      Logger.d('Text added: $outputPath');
      return outputPath;
    } catch (e) {
      Logger.e('Failed to add text', e);
      return null;
    }
  }

  static Future<String?> applyBeauty(
    String imagePath,
    String beautyType,
    double intensity,
  ) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        Logger.e('Image file does not exist: $imagePath');
        return null;
      }

      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        Logger.e('Failed to decode image');
        return null;
      }

      final normalizedIntensity = intensity / 100.0;

      switch (beautyType) {
        case 'smooth':
          image = _applySmoothing(image, normalizedIntensity);
          break;
        case 'whiten':
          image = _applyWhitening(image, normalizedIntensity);
          break;
        case 'slimFace':
          image = _applySlimFace(image, normalizedIntensity);
          break;
        case 'bigEyes':
          image = _applyBigEyes(image, normalizedIntensity);
          break;
        case 'brightEyes':
          image = _applyBrightEyes(image, normalizedIntensity);
          break;
        case 'whitenTeeth':
          image = _applyWhitenTeeth(image, normalizedIntensity);
          break;
        default:
          Logger.e('Unknown beauty type: $beautyType');
          return null;
      }

      final outputBytes = img.encodePng(image);
      final directory = await getApplicationDocumentsDirectory();
      final outputPath = '${directory.path}/beauty_${beautyType}_${DateTime.now().millisecondsSinceEpoch}.png';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(outputBytes);
      Logger.d('Beauty applied: $beautyType, intensity: $intensity, output: $outputPath');
      return outputPath;
    } catch (e, stackTrace) {
      Logger.e('Failed to apply beauty', e, stackTrace);
      return null;
    }
  }

  static img.Image _applySmoothing(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final blurRadius = (intensity * 3).toInt().clamp(1, 5);
    return img.gaussianBlur(image, radius: blurRadius);
  }

  static img.Image _applyWhitening(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final brightness = intensity * 0.3;
    final contrast = 1.0 + intensity * 0.1;
    return img.adjustColor(image, brightness: brightness, contrast: contrast);
  }

  static img.Image _applySlimFace(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final scaleX = 1.0 - intensity * 0.1;
    final newWidth = (image.width * scaleX).toInt();
    final newHeight = image.height;
    final resized = img.copyResize(image, width: newWidth, height: newHeight);
    final result = img.Image(width: image.width, height: image.height);
    img.fill(result, color: img.ColorRgb8(255, 255, 255));
    final offsetX = (image.width - newWidth) ~/ 2;
    img.compositeImage(result, resized, dstX: offsetX, dstY: 0);
    return result;
  }

  static img.Image _applyBigEyes(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final scale = 1.0 + intensity * 0.15;
    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 3;
    final eyeWidth = (image.width * 0.15 * scale).toInt();
    final eyeHeight = (image.height * 0.1 * scale).toInt();
    final leftEyeX = (centerX - image.width * 0.15).toInt();
    final rightEyeX = (centerX + image.width * 0.05).toInt();
    final eyeY = centerY.toInt();
    
    final result = img.Image.from(image);
    
    final leftEye = img.copyCrop(image, x: leftEyeX.clamp(0, image.width - eyeWidth), y: eyeY.clamp(0, image.height - eyeHeight), width: eyeWidth.clamp(1, image.width), height: eyeHeight.clamp(1, image.height));
    final leftEyeScaled = img.copyResize(leftEye, width: (eyeWidth * scale).toInt(), height: (eyeHeight * scale).toInt());
    final leftEyeXScaled = (leftEyeX - (leftEyeScaled.width - eyeWidth) ~/ 2).clamp(0, result.width - leftEyeScaled.width);
    final leftEyeYScaled = (eyeY - (leftEyeScaled.height - eyeHeight) ~/ 2).clamp(0, result.height - leftEyeScaled.height);
    img.compositeImage(result, leftEyeScaled, dstX: leftEyeXScaled, dstY: leftEyeYScaled);
    
    final rightEye = img.copyCrop(image, x: rightEyeX.clamp(0, image.width - eyeWidth), y: eyeY.clamp(0, image.height - eyeHeight), width: eyeWidth.clamp(1, image.width), height: eyeHeight.clamp(1, image.height));
    final rightEyeScaled = img.copyResize(rightEye, width: (eyeWidth * scale).toInt(), height: (eyeHeight * scale).toInt());
    final rightEyeXScaled = (rightEyeX - (rightEyeScaled.width - eyeWidth) ~/ 2).clamp(0, result.width - rightEyeScaled.width);
    final rightEyeYScaled = (eyeY - (rightEyeScaled.height - eyeHeight) ~/ 2).clamp(0, result.height - rightEyeScaled.height);
    img.compositeImage(result, rightEyeScaled, dstX: rightEyeXScaled, dstY: rightEyeYScaled);
    
    return result;
  }

  static img.Image _applyBrightEyes(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final brightness = intensity * 0.4;
    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 3;
    final eyeWidth = (image.width * 0.15).toInt();
    final eyeHeight = (image.height * 0.1).toInt();
    final leftEyeX = (centerX - image.width * 0.15).toInt();
    final rightEyeX = (centerX + image.width * 0.05).toInt();
    final eyeY = centerY.toInt();
    
    final result = img.Image.from(image);
    
    final leftEye = img.copyCrop(image, x: leftEyeX.clamp(0, image.width - eyeWidth), y: eyeY.clamp(0, image.height - eyeHeight), width: eyeWidth.clamp(1, image.width), height: eyeHeight.clamp(1, image.height));
    final leftEyeBright = img.adjustColor(leftEye, brightness: brightness);
    img.compositeImage(result, leftEyeBright, dstX: leftEyeX.clamp(0, result.width - leftEyeBright.width), dstY: eyeY.clamp(0, result.height - leftEyeBright.height));
    
    final rightEye = img.copyCrop(image, x: rightEyeX.clamp(0, image.width - eyeWidth), y: eyeY.clamp(0, image.height - eyeHeight), width: eyeWidth.clamp(1, image.width), height: eyeHeight.clamp(1, image.height));
    final rightEyeBright = img.adjustColor(rightEye, brightness: brightness);
    img.compositeImage(result, rightEyeBright, dstX: rightEyeX.clamp(0, result.width - rightEyeBright.width), dstY: eyeY.clamp(0, result.height - rightEyeBright.height));
    
    return result;
  }

  static img.Image _applyWhitenTeeth(img.Image image, double intensity) {
    if (intensity <= 0) return image;
    final brightness = intensity * 0.5;
    final centerX = image.width ~/ 2;
    final centerY = (image.height * 0.6).toInt();
    final teethWidth = (image.width * 0.2).toInt();
    final teethHeight = (image.height * 0.1).toInt();
    final teethX = (centerX - teethWidth ~/ 2).toInt();
    final teethY = centerY.toInt();
    
    final result = img.Image.from(image);
    final teeth = img.copyCrop(image, x: teethX.clamp(0, image.width - teethWidth), y: teethY.clamp(0, image.height - teethHeight), width: teethWidth.clamp(1, image.width), height: teethHeight.clamp(1, image.height));
    final teethBright = img.adjustColor(teeth, brightness: brightness, saturation: -intensity * 0.3);
    img.compositeImage(result, teethBright, dstX: teethX.clamp(0, result.width - teethBright.width), dstY: teethY.clamp(0, result.height - teethBright.height));
    
    return result;
  }
}
