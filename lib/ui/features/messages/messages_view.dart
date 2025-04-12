import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:go_router/go_router.dart';

class MessagesPage extends StatelessWidget {
  final List<Map<String, dynamic>> contacts = [
    {'name': 'Ibu', 'notified': false},
    {'name': 'Ayah', 'notified': false},
    {'name': 'Kakak', 'notified': true},
    {'name': 'Sayang', 'notified': true},
    {'name': 'Abang', 'notified': true},
  ];

  MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      context.go("/home");
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Find Contact',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Contact',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "D1N",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: Icon + Text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAD7A0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.add, size: 24),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Add New Contact',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "D1N",
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Right side: Notify all contact button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active,
                      color: colorScheme.tertiary,
                      size: 24,
                    ),
                    label: Text(
                      'Notify all contact',
                      style: TextStyle(
                        color: colorScheme.tertiary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: colorScheme.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text('898-8989-8989'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            contact['notified']
                                ? Icons.notifications_active
                                : Icons.notifications_none,
                            color:
                                contact['notified']
                                    ? colorScheme.primary
                                    : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
