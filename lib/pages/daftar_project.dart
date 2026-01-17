// daftar_proyek.dart
import 'package:flutter/material.dart';
import 'home.dart';

const kPurple = Color(0xFF6B257F);

class DaftarProyekScreen extends StatelessWidget {
  const DaftarProyekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = List.generate(12, (index) => 'Project ${index + 1}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ========== HEADER ==========
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFFDFDEDE)),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const Text(
                        'Daftar Project',
                        style: TextStyle(
                          color: Color(0xFF121111),
                          fontSize: 16,
                          fontFamily: 'Encode Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),

                      // home
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                                (route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFFDFDEDE)),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.home_filled,
                            size: 20,
                            color: kPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ========== GRID PROJECT ==========
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: GridView.builder(
                      itemCount: projects.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return _ProjectCard(title: projects[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),

            // ========== FAB + DI POJOK ==========
            Positioned(
              right: 24,
              bottom: 24,
              child: SizedBox(
                width: 64,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    // TODO: aksi tambah project baru
                  },
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;

  const _ProjectCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: aksi ketika project diklik
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_outlined,
              size: 28,
              color: kPurple,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF393333),
                fontSize: 12,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
