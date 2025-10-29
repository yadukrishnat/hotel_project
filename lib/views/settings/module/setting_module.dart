import 'package:flutter/material.dart';

Widget buildSectionCard({
  required String title,
  required IconData icon,
  required Color color,
  required List<Widget> children,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
}

// ℹ️ Info Item
Widget buildInfoItem({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// 📞 Contact Item
Widget buildContactItem({
  required IconData icon,
  required String title,
  required String value,
}) {
  return ListTile(
    leading: Icon(icon, size: 22, color: Colors.green[600]),
    title: Text(
      title,
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ),
    subtitle: Text(
      value,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
    trailing: Icon(Icons.launch, size: 18, color: Colors.green[600]),

    contentPadding: const EdgeInsets.symmetric(vertical: 4),
  );
}

// ⚖️ Legal Item
Widget buildLegalItem({
  required IconData icon,
  required String title,
  required String value,
}) {
  return ListTile(
    leading: Icon(icon, size: 22, color: Colors.purple[600]),
    title: Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
    subtitle: Text(
      value,
      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Colors.grey,
    ),

    contentPadding: const EdgeInsets.symmetric(vertical: 4),
  );
}