import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_record_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> customer;

  const DetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: const Text("Record Details"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildSectionCard(
              title: "Customer Information",

              children: [
                _infoTile(
                  Icons.person,
                  "Customer Name",
                  customer['customerName'],
                ),

                _infoTile(
                  Icons.phone,
                  "Mobile Number",
                  customer['mobileNumber'],
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "Device Information",

              children: [
                _infoTile(
                  Icons.smartphone,
                  "Model Name",
                  customer['modelName'],
                ),

                _infoTile(Icons.numbers, "IMEI Number", customer['imei']),
              ],
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "Purchase Information",

              children: [
                _infoTile(
                  Icons.calendar_today,
                  "Purchase Date",
                  customer['purchaseDate'],
                ),

                _infoTile(
                  Icons.currency_rupee,
                  "Purchase Price",
                  customer['purchasePrice'],
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () async {
                  final bool? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecordScreen(customer: customer),
                    ),
                  );

                  if (updated == true) {
                    Navigator.pop(context, true);
                  }
                },

                icon: const Icon(Icons.edit),

                label: const Text("EDIT RECORD"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,

                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Record"),

                        content: const Text(
                          "Are you sure you want to delete this record?",
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },

                            child: const Text("Cancel"),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },

                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    await DatabaseHelper.instance.deleteCustomer(
                      customer['id'],
                    );

                    Navigator.pop(context, true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Record Deleted")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                icon: const Icon(Icons.delete),

                label: const Text("DELETE RECORD"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, dynamic value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value?.toString() ?? ''),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...children,
          ],
        ),
      ),
    );
  }
}
