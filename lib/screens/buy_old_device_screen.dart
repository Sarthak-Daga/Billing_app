import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import 'package:billing_app/screens/imei_scanner_screen.dart';
import '../services/supabase_service.dart';

class BuyOldDeviceScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;

  const BuyOldDeviceScreen({super.key, this.customer});

  @override
  State<BuyOldDeviceScreen> createState() => _BuyOldDeviceScreenState();
}

class _BuyOldDeviceScreenState extends State<BuyOldDeviceScreen> {
  final TextEditingController customerNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController modelController = TextEditingController();

  final TextEditingController imeiController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  String? savedImagePath;
  File? selectedImage;
  String? existingImageUrl;
  final TextEditingController notesController = TextEditingController();
  bool sellImmediately = false;

  final TextEditingController buyerNameController = TextEditingController();

  final TextEditingController buyerMobileController = TextEditingController();

  final TextEditingController sellingPriceController = TextEditingController();

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
      customerNameController.text = widget.customer!['customer_name'];

      mobileController.text = widget.customer!['mobile_number'];

      modelController.text = widget.customer!['model_name'];

      imeiController.text = widget.customer!['imei'];

      priceController.text = widget.customer!['purchase_price'];

      dateController.text = widget.customer!['purchase_date'];

      notesController.text = widget.customer!['notes'] ?? '';

      if (widget.customer!['image_url'] != null &&
          widget.customer!['image_url'].toString().isNotEmpty) {
        existingImageUrl = widget.customer!['image_url'];
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
    notesController.dispose();
    buyerNameController.dispose();
    buyerMobileController.dispose();
    sellingPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: Text("Buy Old Device"),
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
              "Buy Old Device",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Record a device purchased by the shop",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // CUSTOMER INFO
            _buildSectionCard(
              title: "Seller Information",
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: "Seller Name",
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

                    child: selectedImage == null && existingImageUrl == null
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
                            child: selectedImage != null
                                ? Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.network(
                                    existingImageUrl!,
                                    fit: BoxFit.cover,
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
            _buildSectionCard(
              title: "Condition Notes",
              children: [
                TextField(
                  controller: notesController,
                  maxLines: 4,

                  decoration: InputDecoration(
                    labelText: "Notes",

                    hintText:
                        "Defects, battery health, repairs, accessories etc.",

                    prefixIcon: const Icon(Icons.note_alt_outlined),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: const Text("Sell Immediately"),

              value: sellImmediately,

              onChanged: (value) {
                setState(() {
                  sellImmediately = value;
                });
              },
            ),
            if (sellImmediately)
              _buildSectionCard(
                title: "Sale Information",

                children: [
                  TextField(
                    controller: buyerNameController,

                    decoration: InputDecoration(
                      labelText: "Buyer Name",
                      prefixIcon: const Icon(Icons.person),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: buyerMobileController,

                    keyboardType: TextInputType.phone,

                    maxLength: 10,

                    decoration: InputDecoration(
                      labelText: "Buyer Mobile",
                      prefixIcon: const Icon(Icons.phone),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: sellingPriceController,

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      labelText: "Selling Price",
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
                    String? imageUrl;

                    if (savedImagePath != null) {
                      imageUrl = await SupabaseService.uploadImage(
                        File(savedImagePath!),
                      );
                    }
                    await SupabaseService.addCustomer({
                      'customer_name': customerNameController.text.trim(),

                      'mobile_number': mobileController.text.trim(),

                      'model_name': modelController.text.trim(),

                      'imei': imeiController.text.trim(),

                      'purchase_date': dateController.text.trim(),

                      'purchase_price': priceController.text.trim(),

                      'notes': notesController.text.trim(),

                      'device_type': 'OLD',

                      'status': sellImmediately ? 'SOLD' : 'AVAILABLE',

                      'sold_to': sellImmediately
                          ? buyerNameController.text.trim()
                          : null,

                      'sold_mobile': sellImmediately
                          ? buyerMobileController.text.trim()
                          : null,

                      'selling_price': sellImmediately
                          ? sellingPriceController.text.trim()
                          : null,

                      'sold_date': sellImmediately
                          ? DateTime.now().toString()
                          : null,

                      'image_url': imageUrl,
                    });
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Record Saved")),
                    );
                  } else {
                    String? imageUrl = existingImageUrl;

                    if (savedImagePath != null &&
                        !savedImagePath!.startsWith('http')) {
                      if (existingImageUrl != null &&
                          existingImageUrl!.isNotEmpty) {
                        await SupabaseService.deleteImage(existingImageUrl!);
                      }

                      imageUrl = await SupabaseService.uploadImage(
                        File(savedImagePath!),
                      );
                    }
                    await SupabaseService.updateCustomer(
                      id: widget.customer!['id'],

                      data: {
                        'customer_name': customerNameController.text.trim(),

                        'mobile_number': mobileController.text.trim(),

                        'model_name': modelController.text.trim(),

                        'imei': imeiController.text.trim(),

                        'purchase_date': dateController.text.trim(),

                        'purchase_price': priceController.text.trim(),

                        'notes': notesController.text.trim(),

                        'device_type': 'OLD',

                        'status': widget.customer!['status'],

                        'sold_to': widget.customer!['sold_to'],

                        'sold_mobile': widget.customer!['sold_mobile'],

                        'selling_price': widget.customer!['selling_price'],

                        'sold_date': widget.customer!['sold_date'],
                        'image_url': imageUrl,
                      },
                    );
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
                  widget.customer == null ? "BUY DEVICE" : "UPDATE RECORD",
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
