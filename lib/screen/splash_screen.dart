import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_screen.dart';

// tambahan mute

/// Layar pembuka: animasi masuk singkat, lalu memutuskan tujuan
/// navigasi berikutnya (Login atau Home) berdasarkan status login
/// yang tersimpan.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// SingleTickerProviderStateMixin dibutuhkan setiap kali sebuah State
// memakai AnimationController — dia menyediakan "detak jam" (ticker)
// yang dipakai animasi untuk tahu kapan harus update setiap frame.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController adalah "mesin" di balik animasi: dia berjalan
  // dari 0.0 ke 1.0 selama duration, lalu berhenti. ..forward()
  // langsung menjalankannya begitu dibuat.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  // Interval membagi durasi total controller (0.0–1.0) jadi
  // beberapa bagian, supaya animasi ikon, teks, dan garis muncul
  // BERGANTIAN (staggered), bukan serentak — ikon di 0%-55% durasi,
  // teks di 35%-75%, garis di 55%-100%, sedikit tumpang tindih supaya
  // terasa mengalir.
  late final Animation<double> _iconScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
  );

  late final Animation<double> _iconFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
  );

  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
  );

  late final Animation<Offset> _textSlide =
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
        ),
      );

  late final Animation<double> _lineWidth = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Future.wait menjalankan beberapa proses async SEKALIGUS lalu
    // menunggu semuanya selesai. Di sini: membaca status login DAN
    // menunggu delay minimum splash tampil, dijalankan bersamaan
    // (bukan berurutan) supaya total waktu tunggu tidak dobel.
    await Future.wait([
      AuthController.instance.loadPresistedSession(),
      Future.delayed(const Duration(milliseconds: 1600)),
    ]);
    if (!mounted) return;

    final isLoggedIn = AuthController.instance.value;
    // pushReplacement (bukan push biasa) dipakai supaya SplashScreen
    // hilang dari riwayat navigasi. Kalau pakai push, pengguna bisa
    // menekan tombol back dan kembali melihat splash — yang tidak masuk
    // akal untuk sebuah layar loading.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() { // dispose utuk menghapus ...
    // AnimationController juga wajib di-dispose, sama seperti
    // TextEditingController di LoginScreen.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FadeTransition & ScaleTransition otomatis membaca nilai
            // Animation yang diberikan dan menerapkannya ke child-nya
            // setiap frame — kita tidak perlu setState manual sama sekali.
            FadeTransition(
              opacity: _iconFade,
              child: ScaleTransition(
                scale: _iconScale,
                child: const Icon(
                  Icons.local_florist_rounded,
                  size: 72,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 22),
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Text(
                  'Flowee',
                  style: AppTheme.display(
                    fontSize: 34,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // AnimatedBuilder dipakai saat efeknya tidak tersedia sebagai
            // Transition siap-pakai (di sini: lebar garis yang bertambah).
            // builder dipanggil ulang setiap frame animasi berjalan.
            AnimatedBuilder(
              animation: _lineWidth,
              builder: (context, child) {
                return SizedBox(
                  width: 46 * _lineWidth.value,
                  child: const Divider(
                    color: Colors.white54,
                    thickness: 1.2,
                    height: 1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// pas modif challenge pisahin controller