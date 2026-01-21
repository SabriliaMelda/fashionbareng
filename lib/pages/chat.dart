// chat.dart
import 'package:fashion_mobile/pages/profile.dart';
import 'package:fashion_mobile/pages/settings.dart';
import 'package:fashion_mobile/pages/wishlist.dart';
import 'package:flutter/material.dart';
import 'home.dart'; // <-- tambahkan ini (pastikan file & class sesuai)

const kPurple = Color(0xFF6B257F);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchC = TextEditingController();
  bool _showChats = true;

  final List<_ChatItem> _items = [
    _ChatItem(
      name: 'Kaitlyn',
      message: 'Have a good one!',
      time: '3:02 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Chloe',
      message: 'Hello! Are you available for toni...',
      time: '2:58 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 2,
      isRead: false,
    ),
    _ChatItem(
      name: 'X Client',
      message: 'I’m not gonna pay you.',
      time: '2:46 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: false,
      selected: true,
    ),
    _ChatItem(
      name: 'Phoebe',
      message: 'Good bye!',
      time: '2:41 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Jack',
      message: 'See you again!',
      time: '2:27 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
    _ChatItem(
      name: 'Gibson',
      message: 'Okay, Thank you!',
      time: '2:16 PM',
      avatarUrl: 'https://placehold.co/80x80',
      unread: 0,
      isRead: true,
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.name.toLowerCase().contains(q) || e.message.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const _BottomNavBar(activeIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ===== TOP ROW: Search + bell (avatar dihapus) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _SearchPill(
                      controller: _searchC,
                      onChanged: (v) => setState(() => _query = v),
                      onClear: () {
                        _searchC.clear();
                        setState(() => _query = '');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconPill(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== Title + New message =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Recent chats',
                      style: TextStyle(
                        color: kPurple,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('New message')),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          Text(
                            '+',
                            style: TextStyle(
                              color: kPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'New message',
                            style: TextStyle(
                              color: kPurple,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== Segmented: Chats / Groups =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Segmented(
                left: 'Chats',
                right: 'Groups',
                activeLeft: _showChats,
                onTapLeft: () => setState(() => _showChats = true),
                onTapRight: () => setState(() => _showChats = false),
              ),
            ),

            const SizedBox(height: 12),

            // ===== LIST =====
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = filtered[i];
                  return _SwipeChatRow(
                    item: item,
                    onOpen: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Buka chat: ${item.name}')),
                      );
                    },
                    onArchive: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Arsip: ${item.name}')),
                      );
                    },
                    onDelete: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hapus: ${item.name}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ===================== MODELS =====================
//
class _ChatItem {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int unread;
  final bool isRead;
  final bool selected;

  _ChatItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.unread,
    required this.isRead,
    this.selected = false,
  });
}

//
// ===================== UI PARTS =====================
//
class _SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchPill({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF010101)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Color(0xFF010101),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF010101),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Color(0xFF777777)),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconPill({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF010101)),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final String left;
  final String right;
  final bool activeLeft;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;

  const _Segmented({
    required this.left,
    required this.right,
    required this.activeLeft,
    required this.onTapLeft,
    required this.onTapRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment(0.05, 0.10),
          end: Alignment(1.27, 1.27),
          colors: [Color(0xFF9F82AD), Color(0x3FEBD4F3)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegItem(text: left, active: activeLeft, onTap: onTapLeft),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SegItem(text: right, active: !activeLeft, onTap: onTapRight),
          ),
        ],
      ),
    );
  }
}

class _SegItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _SegItem({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 40,
              offset: Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SwipeChatRow extends StatelessWidget {
  final _ChatItem item;
  final VoidCallback onOpen;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _SwipeChatRow({
    required this.item,
    required this.onOpen,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.name),
      background: const _SwipeBg(
        color: Color(0xFFEBEDFF),
        icon: Icons.folder_outlined,
        alignLeft: true,
      ),
      secondaryBackground: const _SwipeBg(
        color: Color(0xFFFFE7E5),
        icon: Icons.delete_outline,
        alignLeft: false,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onArchive();
        } else {
          onDelete();
        }
        return false;
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.selected ? const Color(0xFF3641B7) : const Color(0xFFE6E6E6),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0CB3B3B3),
                blurRadius: 40,
                offset: Offset(0, 16),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(item.avatarUrl)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF010101),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.time,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (item.unread > 0)
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3641B7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${item.unread}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool alignLeft;

  const _SwipeBg({
    required this.color,
    required this.icon,
    required this.alignLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: const Color(0xFF6B6B6B), size: 22),
    );
  }
}

//
// ================== BOTTOM NAV (CHAT ACTIVE) ==================
//
class _BottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _BottomNavBar({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8ECF4))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_filled,
            active: activeIndex == 0,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          _NavItem(label: 'Wishlist', icon: Icons.favorite_border, active: activeIndex == 1, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WishlistScreen()),
            );
          }),
          _NavItem(label: 'Settings', icon: Icons.settings_outlined, active: activeIndex == 2, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          }),
          _NavItem(label: 'Chat', icon: Icons.chat_bubble_outline, active: activeIndex == 3, onTap: () {}),
          _NavItem(label: 'Profile', icon: Icons.person_outline, active: activeIndex == 4, onTap: () { Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );}),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? kPurple : const Color(0xFFC9CBCE);
    final fontWeight = active ? FontWeight.w700 : FontWeight.w400;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
