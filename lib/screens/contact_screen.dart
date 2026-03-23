import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'amount_screen.dart';
// ignore: duplicate_import
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // 🔷 HEADER (Your theme style)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.blue,
        title: const Text("Send Money"),
        leading: const BackButton(),
        actions: const [
          Icon(Icons.refresh),
          SizedBox(width: 10),
          Icon(Icons.help_outline),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search contact / name",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 👥 QUICK CONTACTS (Horizontal)
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _quickContact("W", "Walii"),
                _quickContact("M", "Mk"),
                _quickContact("S", "Santhu"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📜 LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionTitle("Payments & Chat"),

                _contactTile("Walii", "₹240 - Sent", "20/03",context),
                _contactTile("Gokul", "₹500 - Received", "17/03",context),
                _contactTile("Veera", "₹130 - Paid", "11/03",context),
                _contactTile("Santhu", "₹160 - Paid", "11/03",context),
                _contactTile("Surya", "₹200 - Sent", "10/03",context),
              ],
            ),
          ),
        ],
      ),

      // ➕ FLOATING BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.blue,
        label: const Text("New Payment"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// 🔷 QUICK CONTACT
// ignore: camel_case_types
class _quickContact extends StatelessWidget {
  final String initial;
  final String name;

  const _quickContact(this.initial, this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.blue.withValues(alpha: .2),
            child: Text(
              initial,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 🔷 SECTION TITLE
Widget _sectionTitle(String t) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

// 🔷 CONTACT TILE
Widget _contactTile(String name, String subtitle, String date, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AmountScreen(name: name),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withValues(alpha: .2),
            child: Text(name[0]),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Text(date, style: const TextStyle(fontSize: 12))
        ],
      ),
    ),
  );
}
