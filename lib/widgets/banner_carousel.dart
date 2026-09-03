import 'dart:async';

import 'package:flowee_app/models/promo_banner.dart';
import 'package:flowee_app/widgets/banner_slide.dart';
import 'package:flowee_app/widgets/carousel_dots.dart';
import 'package:flutter/material.dart';

// carousel banner akan bergeser otomatis setiap beberapa detik, untk handling timer seperti ini kita butuh peran stf untuk melakukan perubahan widget pada layar
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.banners});

  final List<PromoBanner> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {

  /**
   * PageController -> untuk mengatur slide mana yg sedang tampil di PageView
   */

  late final PageController _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic akan menjalankan fungsi di dalamnya secara BERULANG-ULANG
    _timer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      final next = (_page + 1) % widget.banners.length;
      _controller.animateToPage(
        next,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic
      );
    });
  }

  @override
  /**
   * Timer HARUS di cancel saat widget dihancukran atau tidak tampil di layar.. 
   * kalo lupa CANCEL timer akan terus mencoba jalan di latar belakang, 
   * walau carousel sudah tidak muncul di layar. 
   * ini salah satu penyebab memory leak di flutter
   */

  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length, // ambil banyaknya data dari sebuah index
            /**
             * logic ketika user melakukan action swipe;
             * dipanggil juga saat pengguna swipe manual, bukan cuma saat digeser otomatis oleh timer. supaya titik indikator dibawah selalu sinkron dengan slide yang tampil
             */
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) => BannerSlide(banner: widget.banners[index]),
          ),
        ),
        SizedBox(height: 10,),
        CarouselDots(
          count: widget.banners.length, // apapun yang diakhiri dengan count, dia nanya berapa yang mau ditampilin dan harus pake method length 
          activeIndex: _page, 
          activeColor: widget.banners[_page].gradientColors.first)
      ],
    );
  }
}