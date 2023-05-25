class ImageUtil {
  // https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/image/util.ts
  // profile is same
  static Map<String, String> exts = {
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
  };

  // https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/image/util.ts
  static Map<String, String> externalExts = {
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
    "gif": "image/gif",
    "svg": "image/svg+xml",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "webp": "image/webp",
  };
}
