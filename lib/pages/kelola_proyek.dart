import 'package:flutter/material.dart';
import 'daftar_project.dart';
import 'jadwal.dart';
import 'pekerja.dart';
import 'chat.dart';
import 'pola.dart';

const kPurple = Color(0xFF6B257F);
const kLightPurple = Color(0xFFF7E1FF);
const kCardPurple = Color(0xFFCA82DE);

class KelolaProyekScreen extends StatelessWidget {
  const KelolaProyekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _MenuGrid(),
                    SizedBox(height: 24),
                    _SectionHeader(title: 'In Progress', count: 6),
                    SizedBox(height: 12),
                    _InProgressList(),
                    SizedBox(height: 24),
                    _SectionHeader(title: 'Task Groups', count: 4),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Office Project',
                      tasksText: '23 Tasks',
                      percent: 70,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Personal Project',
                      tasksText: '30 Tasks',
                      percent: 52,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Daily Study',
                      tasksText: '30 Tasks',
                      percent: 87,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Daily Study',
                      tasksText: '3 Tasks',
                      percent: 87,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== HEADER ATAS ==================
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            'Kelola Proyek',
            style: TextStyle(
              color: Color(0xFF24252C),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          _CircleIconButton(
            icon: Icons.home_filled,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE4E4E4)),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

// ================== MENU GRID ==================
class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Daftar Project', Icons.folder_open),
      ('Jadwal', Icons.event_note),
      ('Pekerja', Icons.people_alt_outlined),
      ('Pola', Icons.auto_graph),
      ('Chat', Icons.chat_bubble_outline),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          _MenuItem(
            label: item.$1,
            icon: item.$2,
            onTap: () {
              // ✅ ROUTING (TAMBAHAN)
              if (item.$1 == 'Daftar Project') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DaftarProyekScreen(),
                  ),
                );
              } else if (item.$1 == 'Jadwal') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JadwalScreen(),
                  ),
                );
              } else if (item.$1 == 'Pekerja') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PekerjaScreen(),
                  ),
                );
              } else if (item.$1 == 'Chat') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(),
                  ),
                );
              }else if (item.$1 == 'Pola') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PolaScreen(),
                  ),
                );
              }

            },
          ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 20 * 2 - 12 * 2) / 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: kPurple),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF393333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== SECTION HEADER ==================
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFF9E9FF),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5F33E1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ================== IN PROGRESS LIST ==================
class _InProgressList extends StatelessWidget {
  const _InProgressList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _InProgressCard(
            title: 'Grocery shopping app design',
            subtitle: 'Office Project',
            cardColor: kCardPurple,
            progressColor: kPurple,
            progress: 0.65,
          ),
          SizedBox(width: 12),
          _InProgressCard(
            title: 'Uber Eats redesign challange',
            subtitle: 'Personal Project',
            cardColor: kLightPurple,
            progressColor: Color(0xFFBA53FF),
            progress: 0.45,
          ),
        ],
      ),
    );
  }
}

class _InProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color progressColor;
  final double progress;

  const _InProgressCard({
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.progressColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6E6A7C),
                ),
              ),
              const Spacer(),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4F2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.folder_open, color: kPurple, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== TASK GROUP CARDS ==================
class _TaskGroupCard extends StatelessWidget {
  final String title;
  final String tasksText;
  final int percent;

  const _TaskGroupCard({
    required this.title,
    required this.tasksText,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 32,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.folder_copy_outlined, color: kPurple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF24252C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tasksText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6E6A7C),
                    ),
                  ),
                ],
              ),
            ),
            _TaskGroupProgressBadge(percent: percent),
          ],
        ),
      ),
    );
  }
}

class _TaskGroupProgressBadge extends StatelessWidget {
  final int percent;
  const _TaskGroupProgressBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4FF),
        shape: BoxShape.circle,
        border: Border.all(color: kPurple, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$percent%',
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF24252C),
        ),
      ),
    );
  }
}
