import 'package:flutter/material.dart';
/**
 * untuk menampilkan gambar dari URL internet
 * 1. ketika gambar sedang dimuat: menampilkan indikator loading
 * 2. agal dimuat: menampilkan ikon pengganti
 */

class FlowerNetworkImage extends StatelessWidget {
  const FlowerNetworkImage({super.key, required this.imageUrl, required this.fallbackIcon, required this.fallbackColor, this.fit = BoxFit.cover});

  final String imageUrl;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      // loading indicator, yang akan dijalankan terus menelus oleh flutter selama gambarnya masih proses download dari internet

      loadingBuilder: (context, child, progress) {
        if (progress == null) return child; 
        return Placeholder(
          color: fallbackColor,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: fallbackColor,
              // kalo flutter tau ukuran total file maka akan menghitung proses download gambar
              // kalo flutter tidak tau ukuran total file, maka akan mengembalikan null
              value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
            ),
          ),
        );
      },
      // errorBuilder, yang akan dipanggil kalau proses DIATAS (loading gambar) gagal total
      errorBuilder: (context, error, stackTrace) {
        return _Placeholder(
          color: fallbackColor,
          child: Icon(fallbackIcon, 
            size: 48, 
            color: fallbackColor,
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.18),
      alignment: Alignment.center,
      child: child,
    );
  }
}