import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DownloadingDialog extends StatefulWidget {
  final String fileUrl;
  const DownloadingDialog({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  @override
  State<DownloadingDialog> createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  double _progress = 0.0;

  void startDownloading() {
    FileDownloader.downloadFile(
      url: widget.fileUrl,
      onProgress: (fileName, progress) {
        setState(
          () {
            _progress = progress;
          },
        );
      },
      onDownloadCompleted: (path) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (_progress).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
