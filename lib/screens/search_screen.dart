import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'details_screen.dart';
import '../services/supabase_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  String selectedFilter = 'ALL';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadCustomers();
  }

  void applyFilters(String query) {
    List<Map<String, dynamic>> results = customers;

    if (selectedFilter == 'AVAILABLE') {
      results = results.where((c) => c['status'] == 'AVAILABLE').toList();
    }

    if (query.isNotEmpty) {
      results = results.where((customer) {
        return customer['customer_name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ) ||
            customer['model_name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ) ||
            customer['mobile_number'].toString().contains(query);
      }).toList();
    }

    setState(() {
      filteredCustomers = results;
    });
  }

  void searchRecords(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCustomers = customers;
      });

      return;
    }

    final results = customers.where((customer) {
      final customerName = customer['customer_name'].toString().toLowerCase();

      final modelName = customer['model_name'].toString().toLowerCase();

      final mobileNumber = customer['mobile_number'].toString().toLowerCase();

      final imei = customer['imei'].toString().toLowerCase();

      final searchText = query.toLowerCase();

      return customerName.contains(searchText) ||
          modelName.contains(searchText) ||
          mobileNumber.contains(searchText) ||
          imei.contains(searchText);
    }).toList();

    setState(() {
      filteredCustomers = results;
    });
  }

  // Future<void> loadCustomers() async {
  //   final data = await DatabaseHelper.instance.getAllCustomers();
  //
  //   setState(() {
  //     customers = data;
  //     filteredCustomers = data;
  //     isLoading = false;
  //   });
  // }
  Future<void> loadCustomers() async {
    final data = await SupabaseService.getCustomers();

    setState(() {
      customers = data;
      filteredCustomers = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: const Text("Search Records"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Search Records",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Search by name, model, IMEI or mobile number",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: searchController,
              onChanged: searchRecords,

              decoration: InputDecoration(
                hintText: "Search anything...",
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Radio<String>(
                  value: 'ALL',
                  groupValue: selectedFilter,

                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });

                    applyFilters(searchController.text);
                  },
                ),

                const Text("All"),

                Radio<String>(
                  value: 'AVAILABLE',
                  groupValue: selectedFilter,

                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });

                    applyFilters(searchController.text);
                  },
                ),

                const Text("Available"),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Results",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : customers.isEmpty
                  ? const Center(child: Text("No Records Found"))
                  : ListView.builder(
                      itemCount: filteredCustomers.length,

                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];

                        return _buildResultCard(customer);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> customer) {
    final bool isSold = customer['status'] == 'SOLD';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.smartphone)),

        title: Row(
          children: [
            Expanded(
              child: Text(
                customer['model_name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            IconButton(
              icon: Icon(
                isSold ? Icons.check_circle : Icons.sell,

                color: isSold ? Colors.red : Colors.green,
              ),

              onPressed: isSold
                  ? null
                  : () async {
                      final buyerNameController = TextEditingController();

                      final buyerMobileController = TextEditingController();

                      final sellingPriceController = TextEditingController();

                      final soldDate = DateTime.now();

                      final result = await showDialog<bool>(
                        context: context,

                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Sell Device"),

                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  TextField(
                                    controller: buyerNameController,

                                    decoration: const InputDecoration(
                                      labelText: "Buyer Name",
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  TextField(
                                    controller: buyerMobileController,

                                    keyboardType: TextInputType.phone,

                                    maxLength: 10,

                                    decoration: const InputDecoration(
                                      labelText: "Buyer Mobile",
                                      counterText: "",
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  TextField(
                                    controller: sellingPriceController,

                                    keyboardType: TextInputType.number,

                                    decoration: const InputDecoration(
                                      labelText: "Selling Price",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },

                                child: const Text("Cancel"),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },

                                child: const Text("Sell"),
                              ),
                            ],
                          );
                        },
                      );
                      if (result != true) return;
                      await SupabaseService.sellDevice(
                        id: customer['id'],

                        buyerName: buyerNameController.text.trim(),

                        buyerMobile: buyerMobileController.text.trim(),

                        sellingPrice: sellingPriceController.text.trim(),
                      );

                      await loadCustomers();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Device Sold")),
                      );
                    },
            ),
          ],
        ),

        subtitle: Text(
          "👤 ${customer['customer_name']}\n"
          "📞 +91 ${customer['mobile_number']}\n"
          "🔢 ${customer['imei']}",
        ),

        isThreeLine: true,

        onTap: () async {
          final bool? refreshNeeded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(customer: customer),
            ),
          );

          if (refreshNeeded == true) {
            await loadCustomers();
          }
        },
      ),
    );
  }
}
