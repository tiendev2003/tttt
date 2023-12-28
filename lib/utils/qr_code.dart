import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';

class QRCodeScanner {
  static void scanQRCode(Function(String) onScanSuccess) {
    QRViewController? qrViewController; // Use nullable QRViewController
    QRView qrView = QRView(
      key: GlobalKey(),
      onQRViewCreated: (controller) {
        qrViewController = controller;
        qrViewController!.scannedDataStream.listen((scanData) {
          if (scanData.code != null) {
            onScanSuccess(scanData.code!); // Use ! to assert non-nullability
          }
        });
      },
    );
    // Display the QR Code Scanner on the screen and handle success after scanning
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => qrView));
  }
}
