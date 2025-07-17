import 'package:share_plus/share_plus.dart';

class MakeRefundRequestModel {
  String? productName;
  String? requestItemId;
  String? refundQuantity;
  String? refundReason;
  String? preferredOptions;
  String? additionalInformation;
  String? fields;
  XFile? file;

  MakeRefundRequestModel({
    this.productName,
    this.requestItemId,
    this.refundQuantity,
    this.refundReason,
    this.preferredOptions,
    this.additionalInformation,
    this.fields,
    this.file
  });
}