import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import 'package:billing_app/screens/imei_scanner_screen.dart';

class AddRecordScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;

  const AddRecordScreen({super.key, this.customer});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final TextEditingController customerNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController modelController = TextEditingController();

  final TextEditingController imeiController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  String? savedImagePath;
  File? selectedImage;

  Future<void> scanImei() async {
    final result = await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const ImeiScannerScreen()),
    );

    if (result != null) {
      setState(() {
        imeiController.text = result.toString();
      });
    }
  }

  Future<void> showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),

                title: const Text("Camera"),

                onTap: () {
                  Navigator.pop(context);

                  pickImageFromCamera();
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),

                title: const Text("Gallery"),

                onTap: () {
                  Navigator.pop(context);

                  pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final String? compressedPath = await ImageService.compressAndSaveImage(
        image.path,
      );

      if (compressedPath != null) {
        setState(() {
          selectedImage = File(compressedPath);

          savedImagePath = compressedPath;
        });
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String? compressedPath = await ImageService.compressAndSaveImage(
        image.path,
      );

      if (compressedPath != null) {
        setState(() {
          selectedImage = File(compressedPath);
          savedImagePath = compressedPath;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      customerNameController.text = widget.customer!['customerName'];

      mobileController.text = widget.customer!['mobileNumber'];

      modelController.text = widget.customer!['modelName'];

      imeiController.text = widget.customer!['imei'];

      priceController.text = widget.customer!['purchasePrice'];

      dateController.text = widget.customer!['purchaseDate'];

      if (widget.customer!['photoPath'] != null &&
          widget.customer!['photoPath'].toString().isNotEmpty) {
        selectedImage = File(widget.customer!['photoPath']);

        savedImagePath = widget.customer!['photoPath'];
      }
    } else {
      final now = DateTime.now();

      dateController.text =
          "${now.day.toString().padLeft(2, '0')}/"
          "${now.month.toString().padLeft(2, '0')}/"
          "${now.year}";
    }
  }

  @override
  void dispose() {
    customerNameController.dispose();
    mobileController.dispose();
    modelController.dispose();
    imeiController.dispose();
    priceController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: Text(widget.customer == null ? "Add New Device" : "Edit Record"),
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
            const Text(
              "Add New Device",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Fill in the device details",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // CUSTOMER INFO
            _buildSectionCard(
              title: "Customer Information",
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: "Customer Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 120,

                  child: OutlinedButton(
                    onPressed: showImagePickerOptions,

                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    child: selectedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 35),
                              SizedBox(height: 8),
                              Text("Upload Photo"),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // DEVICE INFO
            _buildSectionCard(
              title: "Device Information",
              children: [
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(
                    labelText: "Model Name",
                    prefixIcon: const Icon(Icons.smartphone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: imeiController,
                        keyboardType: TextInputType.number,
                        maxLength: 15,

                        decoration: InputDecoration(
                          labelText: "IMEI Number",
                          prefixIcon: const Icon(Icons.numbers),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      height: 60,
                      width: 60,

                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: IconButton(
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),

                        onPressed: scanImei,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // PURCHASE INFO
            _buildSectionCard(
              title: "Purchase Information",
              children: [
                TextField(
                  controller: dateController,
                  readOnly: true,

                  decoration: InputDecoration(
                    labelText: "Purchase Date",
                    prefixIcon: const Icon(Icons.calendar_today),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Purchase Price",
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  if (widget.customer == null) {
                    await DatabaseHelper.instance.insertCustomer({
                      'customerName': customerNameController.text,

                      'mobileNumber': mobileController.text,

                      'modelName': modelController.text,

                      'imei': imeiController.text,

                      'purchaseDate': dateController.text,

                      'purchasePrice': priceController.text,

                      'photoPath': savedImagePath ?? '',
                    });
                    Navigator.pop(context, false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Record Saved")),
                    );
                  } else {
                    await DatabaseHelper.instance.updateCustomer({
                      'id': widget.customer!['id'],

                      'customerName': customerNameController.text,

                      'mobileNumber': mobileController.text,

                      'modelName': modelController.text,

                      'imei': imeiController.text,

                      'purchaseDate': dateController.text,

                      'purchasePrice': priceController.text,

                      'photoPath':
                          savedImagePath ?? widget.customer!['photoPath'],
                    });
                    Navigator.pop(context, true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Record Updated")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: Text(
                  widget.customer == null ? "SAVE RECORD" : "UPDATE RECORD",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...children,
          ],
        ),
      ),
    );
  }
}
