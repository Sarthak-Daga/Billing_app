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
}
