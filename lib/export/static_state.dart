import 'package:flutter/material.dart';
import 'package:sticker_import/components/objects/attachment.dart';

class StaticExportState {
  final int id;
  final int peerId;
  final int processed;
  final int size;
  final int? lastMessageId;
  final int? topMessageId;

  final int? maxMessagesAllowed;
  final int? maxAttachmentSize;
  final DateTimeRange? dateRange;
  final Set<AttachmentType> attachmentTypes;

  const StaticExportState({
    required this.id,
    required this.peerId,
    required this.processed,
    required this.size,
    this.lastMessageId,
    this.topMessageId,
    this.maxMessagesAllowed,
    this.maxAttachmentSize,
    this.dateRange,
    required this.attachmentTypes,
  });
}
