import 'package:flutter/material.dart';

enum AttachmentType { photo, video, music, doc, podcast, poll, sticker, story }

class Attachment {
  const Attachment(this.type, this.name, this.icon);

  final AttachmentType type;
  final String name;
  final IconData icon;
}
