import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/views/add_activity_page.dart';
import 'package:flutter_application_uas_aktivitas/views/details_activity_page.dart';
import 'package:flutter_application_uas_aktivitas/views/edit_activity_page.dart';
import 'package:get/get.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Mengubah warna teks AppBar menjadi putih
          ),
        ),
        backgroundColor:
            Colors.lightBlue, // Mengubah warna AppBar menjadi lightBlue
      ),
      body: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            final activity = controller.activities[index];

            return Card(
              color: Colors.orangeAccent.withOpacity(
                  0.8), // Mengubah warna Card menjadi orangeAccent dengan transparansi
              child: ListTile(
                onTap: () => Get.to(() => DetailsActivityPage(index: index)),
                title: Text(
                  activity.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        Colors.white, // Mengubah warna teks judul menjadi putih
                  ),
                ),
                subtitle: Text(
                  '${activity.date.day}/${activity.date.month}/${activity.date.year}',
                  style: const TextStyle(
                    color: Colors
                        .white70, // Mengubah warna teks subtitle menjadi putih dengan transparansi
                  ),
                ),
                trailing: SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            TimeOfDay.fromDateTime(activity.date)
                                .format(context),
                            style: const TextStyle(
                              color: Colors
                                  .white70, // Mengubah warna teks trailing menjadi putih dengan transparansi
                            ),
                          ),
                          Text(
                            activity.duration.formatDuration(),
                            style: const TextStyle(
                              color: Colors
                                  .white70, // Mengubah warna teks trailing menjadi putih dengan transparansi
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          switch (v) {
                            case 'Edit':
                              Get.to(() => EditActivityPage(index: index));
                              break;
                            case 'Hapus':
                              _showDeleteDialog(index);
                              break;
                            default:
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Edit', 'Hapus'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors
            .lightBlue, // Mengubah warna background FloatingActionButton menjadi lightBlue
        child: const Icon(
          Icons.add,
          color: Colors.white, // Mengubah warna ikon menjadi putih
        ),
        onPressed: () => Get.to(() => const AddActivityPage()),
      ),
    );
  }

  void _showDeleteDialog(int index) async {
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
      controller.deleteActivity(controller.activities[index]);
    }
  }
}
