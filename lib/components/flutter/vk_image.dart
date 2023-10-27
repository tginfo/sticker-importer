import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vkget/vkget.dart';

class VKGetImageProvider extends ImageProvider<NetworkImage>
    implements NetworkImage {
  /// Creates an object that fetches the image at the given URL with VKGet.
  const VKGetImageProvider(this.url, this.vk, {this.scale = 1.0});

  @override
  final String url;
  @override
  final double scale;
  final VKGet vk;

  @override
  Future<VKGetImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<VKGetImageProvider>(this);
  }

  @override
  // ignore: deprecated_member_use
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key as VKGetImageProvider, chunkEvents,
          decodeDeprecated: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<NetworkImage>('Image key', key),
      ],
    );
  }

  @override
  ImageStreamCompleter loadBuffer(
      NetworkImage key,
      // ignore: deprecated_member_use
      DecoderBufferCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decodeBufferDeprecated: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<NetworkImage>('Image key', key),
      ],
    );
  }

  @override
  ImageStreamCompleter loadImage(
      NetworkImage key, ImageDecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<NetworkImage>('Image key', key),
      ],
    );
  }

  Future<Codec> _loadAsync(
    NetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents, {
    ImageDecoderCallback? decode,
    // ignore: deprecated_member_use
    DecoderBufferCallback? decodeBufferDeprecated,
    // ignore: deprecated_member_use
    DecoderCallback? decodeDeprecated,
  }) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);

      final HttpClientResponse response = await vk.fetch(resolved);
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<List<int>>(<int>[]);
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );
      if (bytes.lengthInBytes == 0) {
        throw Exception('NetworkImage is an empty file: $resolved');
      }

      if (decode != null) {
        final ImmutableBuffer buffer =
            await ImmutableBuffer.fromUint8List(bytes);
        return decode(buffer);
      } else if (decodeBufferDeprecated != null) {
        final ImmutableBuffer buffer =
            await ImmutableBuffer.fromUint8List(bytes);
        return decodeBufferDeprecated(buffer);
      } else {
        assert(decodeDeprecated != null);
        return decodeDeprecated!(bytes);
      }
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      // ignore: unawaited_futures
      chunkEvents.close();
    }
  }

  @override
  void resolveStreamForKey(ImageConfiguration configuration, ImageStream stream,
      NetworkImage key, ImageErrorListener handleError) {
    super.resolveStreamForKey(configuration, stream, key, handleError);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'VKGetImage')}("$url", scale: $scale)';

  @override
  Never get headers => throw UnimplementedError();
}

class VKGetImage extends Image {
  VKGetImage.vk(
    String uri,
    VKGet vk, {
    double scale = 1.0,
    super.key,
    super.frameBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
    super.filterQuality,
  }) : super(image: VKGetImageProvider(uri, vk, scale: scale));
}

class VKGetFadeInImage extends FadeInImage {
  VKGetFadeInImage.vk({
    super.key,
    required String placeholder,
    super.placeholderErrorBuilder,
    required String image,
    required VKGet vk,
    super.imageErrorBuilder,
    AssetBundle? bundle,
    double? placeholderScale,
    double imageScale = 1.0,
    super.excludeFromSemantics = false,
    super.imageSemanticLabel,
    super.fadeOutDuration = const Duration(milliseconds: 300),
    super.fadeOutCurve = Curves.easeOut,
    super.fadeInDuration = const Duration(milliseconds: 700),
    super.fadeInCurve = Curves.easeIn,
    super.width,
    super.height,
    super.fit,
    super.placeholderFit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    int? placeholderCacheWidth,
    int? placeholderCacheHeight,
    int? imageCacheWidth,
    int? imageCacheHeight,
  }) : super(
          placeholder: placeholderScale != null
              ? ResizeImage.resizeIfNeeded(
                  placeholderCacheWidth,
                  placeholderCacheHeight,
                  ExactAssetImage(placeholder,
                      bundle: bundle, scale: placeholderScale))
              : ResizeImage.resizeIfNeeded(
                  placeholderCacheWidth,
                  placeholderCacheHeight,
                  AssetImage(placeholder, bundle: bundle)),
          image: ResizeImage.resizeIfNeeded(
            imageCacheWidth,
            imageCacheHeight,
            VKGetImageProvider(image, vk, scale: imageScale),
          ),
        );
}
