import 'package:meta/meta.dart';

class ScannedQRCodeResult {
  final String qrCode;

  ScannedQRCodeResult(this.qrCode);
}

class AddedCodeResult {
  final bool isOk;

  AddedCodeResult({@required this.isOk});
}