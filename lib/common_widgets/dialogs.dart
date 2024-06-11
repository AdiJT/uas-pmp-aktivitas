import 'package:flutter/material.dart';

void showDeleteDialog({required void Function() deleteAction, required BuildContext context}) async {
  final delete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.orangeAccent
          .withOpacity(0.8), // Mengubah warna background AlertDialog
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Apakah anda yakin ingin menghapus?',
            style: TextStyle(
              color: Colors.white, // Mengubah warna teks AlertDialog
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red, // Mengubah warna teks tombol Hapus
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: Colors.white, // Mengubah warna teks tombol Batal
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );

  if (delete != null && delete == true) {
    deleteAction();
  }
}
