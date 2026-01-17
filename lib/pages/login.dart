import 'package:flutter/material.dart';
import 'package:fashion_mobile/pages/home.dart'; // <-- tetap

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // toggle: true = telepon, false = email
  bool _usePhone = true;

  final TextEditingController _phoneC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();

  // password
  final TextEditingController _passC = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phoneC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // tetap (meskipun tidak dipakai)

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ===== BACK BUTTON =====
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 41,
                            height: 41,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFE8ECF4),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Color(0xFF1E232C),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ===== TITLE =====
                        const Text(
                          'Welcome back! Glad\nto see you, Again!',
                          style: TextStyle(
                            color: Color(0xFF1E232C),
                            fontSize: 30,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== TELEPON / EMAIL (TOGGLE) =====
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFE8ECF4),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              if (_usePhone) ...[
                                const Text(
                                  '+62',
                                  style: TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                    width: 1,
                                    height: 22,
                                    color: const Color(0xFFE8ECF4)),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: TextField(
                                  controller: _usePhone ? _phoneC : _emailC,
                                  keyboardType: _usePhone
                                      ? TextInputType.phone
                                      : TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: _usePhone
                                        ? '081xxxxxxxx'
                                        : 'johndoe@contoh.com',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF8390A1),
                                      fontSize: 15,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ===== TOGGLE TEXT (sesuai gambar) =====
                        GestureDetector(
                          onTap: () => setState(() => _usePhone = !_usePhone),
                          child: Text(
                            _usePhone
                                ? '*Gunakan Email Sebagai Gantinya'
                                : '*Gunakan Nomor Telepon Sebagai Gantinya',
                            style: const TextStyle(
                              color: Color(0xFF6B257F),
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== PASSWORD FIELD =====
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7F8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFE8ECF4),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _passC,
                                  obscureText: _obscure,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Kata sandi',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF8390A1),
                                      fontSize: 15,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: const Color(0xFF8390A1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ===== FORGOT PASSWORD =====
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF6A707C),
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ===== LOGIN BUTTON =====
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B257F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== OR LOGIN WITH =====
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 1,
                                    color: const Color(0xFFE8ECF4))),
                            const SizedBox(width: 12),
                            const Text(
                              'Or Login with',
                              style: TextStyle(
                                color: Color(0xFF6A707C),
                                fontSize: 14,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Container(
                                    height: 1,
                                    color: const Color(0xFFE8ECF4))),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ===== SOCIAL BUTTONS =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _socialButton('assets/images/facebook.png'),
                            _socialButton('assets/images/google.png'),
                            _socialButton('assets/images/instagram.png'),
                          ],
                        ),

                        // ===== PUSH BOTTOM CONTENT SAFELY =====
                        const Expanded(child: SizedBox()),

                        // ===== REGISTER TEXT =====
                        Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Don’t have an account? ',
                                  style: TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Register Now',
                                  style: const TextStyle(
                                    color: Color(0xFF6B257F),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== SOCIAL BUTTON WIDGET =====
  Widget _socialButton(String assetPath) {
    return Container(
      width: 105,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xFFE8ECF4)),
      ),
      child: Center(
        child: Image.asset(assetPath,
            width: 26, height: 26, fit: BoxFit.contain),
      ),
    );
  }
}
