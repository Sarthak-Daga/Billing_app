import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  static Future<void> addCustomer(Map<String, dynamic> data) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await supabase.from('customers').insert({...data, 'user_id': user.id});
  }

  static Future<List<Map<String, dynamic>>> getCustomers() async {
    final response = await supabase
        .from('customers')
        .select()
        .order('id', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> updateCustomer({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await supabase.from('customers').update(data).eq('id', id);
  }

  static Future<void> sellDevice({
    required int id,
    required String buyerName,
    required String buyerMobile,
    required String sellingPrice,
  }) async {
    await supabase
        .from('customers')
        .update({
          'status': 'SOLD',

          'sold_to': buyerName,

          'sold_mobile': buyerMobile,

          'selling_price': sellingPrice,

          'sold_date': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  static Future<void> deleteCustomer(int id) async {
    await supabase.from('customers').delete().eq('id', id);
  }
}
