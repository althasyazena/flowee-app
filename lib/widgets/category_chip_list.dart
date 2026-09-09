import 'package:flowee_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({super.key, required this.categories, required this.selectedCategory, required this.onSelected});

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated( //bedanya akan menimbulkan action yang beda2 di setiap listnya. ga manggil secara hard code, tapi berdasarkan dummy data yang kita punya, bedanya ini dipisah listnya karna punya data yang berbeda (karna punya action yg beda beda)
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return ChoiceChip(
            label: Text(category), // ambil dari data class
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            selectedColor: AppTheme.primary,
            showCheckmark: false,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13
            ),
            backgroundColor: isSelected ? AppTheme.primaryDark : AppTheme.primarySoft.withValues(alpha: 0.5),
            side: BorderSide.none,
            elevation: 0,
            pressElevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        }, // apa yg akan dilampirkan
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemCount: categories.length // akan membaca ada berapa kategori
      ),
    );
  }
}