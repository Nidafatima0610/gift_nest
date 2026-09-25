import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/creator_model.dart';
import '../../../models/product_model.dart';

/// Data class representing an occasion for the Home screen.
class OccasionItem {
  final String id;
  final String name;
  final String emoji;
  final IconData icon;
  final Color accentColor;

  const OccasionItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
    required this.accentColor,
  });
}

/// Curated local demo data for Gift Nest Home screen.
class HomeDemoData {
  HomeDemoData._();

  /// Curated occasions for "Shop by Occasion".
  static const List<OccasionItem> occasions = [
    OccasionItem(
      id: 'birthday',
      name: 'Birthday',
      emoji: '🎂',
      icon: Icons.cake_outlined,
      accentColor: AppColors.softRose,
    ),
    OccasionItem(
      id: 'anniversary',
      name: 'Anniversary',
      emoji: '💍',
      icon: Icons.favorite_outline_rounded,
      accentColor: AppColors.primary,
    ),
    OccasionItem(
      id: 'graduation',
      name: 'Graduation',
      emoji: '🎓',
      icon: Icons.school_outlined,
      accentColor: AppColors.darkPrimary,
    ),
    OccasionItem(
      id: 'eid',
      name: 'Eid',
      emoji: '🌙',
      icon: Icons.nights_stay_outlined,
      accentColor: AppColors.starGold,
    ),
    OccasionItem(
      id: 'wedding',
      name: 'Wedding',
      emoji: '💐',
      icon: Icons.local_florist_outlined,
      accentColor: AppColors.softRose,
    ),
    OccasionItem(
      id: 'new_baby',
      name: 'New Baby',
      emoji: '👶',
      icon: Icons.child_care_outlined,
      accentColor: AppColors.success,
    ),
  ];

  /// Curated trending products with realistic Pakistani market data.
  static const List<ProductModel> trendingProducts = [
    ProductModel(
      id: 'prod_1',
      title: 'Personalized Name Mug',
      description: 'Handcrafted ceramic mug with custom calligraphy name and 24k gold luster rim.',
      price: 1450.0,
      originalPrice: 1750.0,
      imageUrls: ['https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=400'],
      categoryId: 'home_living',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.9,
      reviewCount: 38,
      isCustomizable: true,
      customizableFields: ['Recipient Name', 'Color Choice'],
      occasions: ['Birthday', 'Anniversary'],
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_2',
      title: 'Custom Photo Frame',
      description: 'Solid walnut wooden frame with personalized engraved message and matte print.',
      price: 2800.0,
      originalPrice: 3200.0,
      imageUrls: ['https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400'],
      categoryId: 'keepsakes',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 5.0,
      reviewCount: 52,
      isCustomizable: true,
      customizableFields: ['Photo Upload', 'Custom Note'],
      occasions: ['Anniversary', 'Wedding'],
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_3',
      title: 'Mini Self-Care Box',
      description: 'Aromatherapy bath salts, organic lip scrub, and hand-poured lavender soy candle.',
      price: 3950.0,
      originalPrice: 4500.0,
      imageUrls: ['https://images.unsplash.com/photo-1549465220-1a8b9238cd48?q=80&w=400'],
      categoryId: 'care_packages',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 4.8,
      reviewCount: 29,
      isCustomizable: true,
      customizableFields: ['Gift Card Message'],
      occasions: ['Birthday', 'Just Because'],
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_4',
      title: 'Handmade Charm Bracelet',
      description: 'Delicate freshwater pearl and rose gold plated charm bracelet with custom initials.',
      price: 1850.0,
      imageUrls: ['https://images.unsplash.com/photo-1611591475816-a794b6ecffba?q=80&w=400'],
      categoryId: 'jewelry',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.9,
      reviewCount: 44,
      isCustomizable: true,
      customizableFields: ['Initial Letter'],
      occasions: ['Birthday', 'Graduation'],
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_5',
      title: 'Personalized Leather Journal',
      description: 'Full-grain vintage brown leather notebook with refillable parchment paper and initials.',
      price: 2400.0,
      originalPrice: 2800.0,
      imageUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=400'],
      categoryId: 'stationery',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 4.7,
      reviewCount: 19,
      isCustomizable: true,
      customizableFields: ['Embossed Initials'],
      occasions: ['Graduation', 'Eid'],
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_6',
      title: 'Artisanal Scented Candle Set',
      description: 'Trio of hand-poured soy wax candles: Oud & Rose, Vanilla Amber, and Jasmine Breeze.',
      price: 2650.0,
      imageUrls: ['https://images.unsplash.com/photo-1602874801007-bd458bb1b8b8?q=80&w=400'],
      categoryId: 'home_fragrance',
      creatorId: 'creator_2',
      creatorName: 'The Candle Corner',
      rating: 5.0,
      reviewCount: 67,
      isCustomizable: false,
      occasions: ['Eid', 'Wedding', 'Anniversary'],
      isPopular: true,
    ),
  ];

  /// Curated local creators.
  static const List<CreatorModel> creators = [
    CreatorModel(
      id: 'creator_1',
      name: 'Sana Farooq',
      studioName: "Sana's Studio",
      bio: 'Creating timeless resin art, customized drinkware, and delicate handcrafted jewelry.',
      location: 'Karachi, PK',
      rating: 4.9,
      totalProducts: 24,
      isVerified: true,
    ),
    CreatorModel(
      id: 'creator_2',
      name: 'Bilal & Zara',
      studioName: 'The Candle Corner',
      bio: 'Eco-conscious artisanal soy candles infused with locally sourced botanical oils.',
      location: 'Lahore, PK',
      rating: 5.0,
      totalProducts: 18,
      isVerified: true,
    ),
    CreatorModel(
      id: 'creator_3',
      name: 'Noor ul Huda',
      studioName: 'Crafted by Noor',
      bio: 'Master leather artisan and calligrapher bringing timeless keepsake journals to life.',
      location: 'Islamabad, PK',
      rating: 4.8,
      totalProducts: 31,
      isVerified: true,
    ),
    CreatorModel(
      id: 'creator_4',
      name: 'Ayesha Tariq',
      studioName: 'Little Things PK',
      bio: 'Boutique gifting specialist curating thoughtful self-care and celebratory hampers.',
      location: 'Lahore, PK',
      rating: 4.9,
      totalProducts: 42,
      isVerified: true,
    ),
  ];
}
