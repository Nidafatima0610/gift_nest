import '../../../models/product_model.dart';

/// Categories available for filtering in the Explore screen.
class ExploreCategories {
  static const String all = 'All';
  static const String birthday = 'Birthday';
  static const String anniversary = 'Anniversary';
  static const String eid = 'Eid';
  static const String wedding = 'Wedding';
  static const String graduation = 'Graduation';
  static const String newBaby = 'New Baby';
  static const String selfCare = 'Self Care';
  static const String forHer = 'For Her';
  static const String forHim = 'For Him';
  static const String handmade = 'Handmade';

  static const List<String> list = [
    all,
    birthday,
    anniversary,
    eid,
    wedding,
    graduation,
    newBaby,
    selfCare,
    forHer,
    forHim,
    handmade,
  ];
}

/// Sort options supported in Explore marketplace.
enum ExploreSortOption {
  recommended('Recommended'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  newest('Newest');

  final String label;
  const ExploreSortOption(this.label);
}

/// Price range filter options.
class PriceFilterOption {
  final String label;
  final double? min;
  final double? max;

  const PriceFilterOption({
    required this.label,
    this.min,
    this.max,
  });

  bool matches(double price) {
    if (min != null && price < min!) return false;
    if (max != null && price > max!) return false;
    return true;
  }
}

/// Curated demo catalog products for Gift Nest Explore Screen.
class ExploreDemoData {
  ExploreDemoData._();

  static const List<PriceFilterOption> priceRanges = [
    PriceFilterOption(label: 'Under Rs. 1,000', max: 999.99),
    PriceFilterOption(label: 'Rs. 1,000–2,500', min: 1000.0, max: 2500.0),
    PriceFilterOption(label: 'Rs. 2,500–5,000', min: 2500.01, max: 5000.0),
    PriceFilterOption(label: 'Rs. 5,000+', min: 5000.01),
  ];

  static const List<String> giftTypes = [
    'Personalized',
    'Handmade',
    'Gift Box',
  ];

  static const List<String> recipients = [
    'For Her',
    'For Him',
    'Kids',
    'Parents',
    'Friends',
    'Partner',
  ];

  static final List<ProductModel> catalogProducts = [
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
      recipients: ['For Her', 'For Him', 'Friends'],
      interests: ['Personalized'],
      createdAt: DateTime(2026, 3, 1),
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
      recipients: ['Partner', 'Parents'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 5),
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
      occasions: ['Birthday', 'Self Care'],
      recipients: ['For Her', 'Friends'],
      interests: ['Gift Box', 'Self Care'],
      createdAt: DateTime(2026, 2, 20),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_4',
      title: 'Handmade Bracelet',
      description: 'Delicate freshwater pearl and rose gold plated charm bracelet with custom initials.',
      price: 1850.0,
      imageUrls: ['https://images.unsplash.com/photo-1611591475816-a794b6ecffba?q=80&w=400'],
      categoryId: 'jewelry',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.9,
      reviewCount: 44,
      isCustomizable: false,
      occasions: ['Birthday', 'Graduation', 'Handmade'],
      recipients: ['For Her', 'Partner', 'Friends'],
      interests: ['Handmade'],
      createdAt: DateTime(2026, 3, 10),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_5',
      title: 'Personalized Journal',
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
      occasions: ['Graduation', 'Eid', 'Handmade'],
      recipients: ['For Him', 'For Her', 'Friends'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 8),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_6',
      title: 'Scented Candle Set',
      description: 'Trio of hand-poured soy wax candles: Oud & Rose, Vanilla Amber, and Jasmine Breeze.',
      price: 2650.0,
      imageUrls: ['https://images.unsplash.com/photo-1602874801007-bd458bb1b8b8?q=80&w=400'],
      categoryId: 'home_fragrance',
      creatorId: 'creator_2',
      creatorName: 'The Candle Corner',
      rating: 5.0,
      reviewCount: 67,
      isCustomizable: false,
      occasions: ['Eid', 'Wedding', 'Anniversary', 'Self Care', 'Handmade'],
      recipients: ['For Her', 'Parents', 'Friends'],
      interests: ['Handmade', 'Self Care'],
      createdAt: DateTime(2026, 1, 15),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_7',
      title: 'Custom Keychain',
      description: 'Handcrafted leather and brass engraved keychain with custom name stamp.',
      price: 850.0,
      originalPrice: 1100.0,
      imageUrls: ['https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?q=80&w=400'],
      categoryId: 'accessories',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.8,
      reviewCount: 31,
      isCustomizable: true,
      customizableFields: ['Name Stamp'],
      occasions: ['Birthday', 'Graduation', 'Handmade'],
      recipients: ['For Him', 'Friends', 'Partner'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 12),
      isPopular: false,
    ),
    ProductModel(
      id: 'prod_8',
      title: 'Eid Gift Hamper',
      description: 'Deluxe celebration basket with gourmet baklava, royal amber perfume, and brass crescent tray.',
      price: 5400.0,
      originalPrice: 6200.0,
      imageUrls: ['https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=400'],
      categoryId: 'care_packages',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 5.0,
      reviewCount: 41,
      isCustomizable: true,
      customizableFields: ['Personalized Greeting Card'],
      occasions: ['Eid'],
      recipients: ['Parents', 'Friends', 'Partner'],
      interests: ['Gift Box'],
      createdAt: DateTime(2026, 3, 15),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_9',
      title: 'Minimal Jewelry Box',
      description: 'Velvet-lined wooden trinket box with delicate brass inlay and hand-carved floral latch.',
      price: 2200.0,
      imageUrls: ['https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=400'],
      categoryId: 'keepsakes',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 4.9,
      reviewCount: 22,
      isCustomizable: false,
      occasions: ['Birthday', 'Anniversary', 'Wedding', 'Handmade'],
      recipients: ['For Her', 'Partner'],
      interests: ['Handmade'],
      createdAt: DateTime(2026, 2, 28),
      isPopular: false,
    ),
    ProductModel(
      id: 'prod_10',
      title: 'Memory Scrapbook',
      description: 'Hardbound vintage scrapbook with handmade kraft pages, corner stickers, and gold pen.',
      price: 3200.0,
      originalPrice: 3800.0,
      imageUrls: ['https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=400'],
      categoryId: 'stationery',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 4.8,
      reviewCount: 35,
      isCustomizable: true,
      customizableFields: ['Front Cover Name'],
      occasions: ['Anniversary', 'Wedding', 'Handmade'],
      recipients: ['Partner', 'Friends'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 2),
      isPopular: true,
    ),
    ProductModel(
      id: 'prod_11',
      title: 'New Baby Welcome Keepsake',
      description: 'Hand-painted wooden birth announcement plaque with baby name, date, weight, and milestone cards.',
      price: 4200.0,
      imageUrls: ['https://images.unsplash.com/photo-1519689680058-324335c77eba?q=80&w=400'],
      categoryId: 'keepsakes',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 5.0,
      reviewCount: 18,
      isCustomizable: true,
      customizableFields: ['Baby Name', 'Birth Details'],
      occasions: ['New Baby'],
      recipients: ['Parents', 'Kids'],
      interests: ['Gift Box', 'Personalized'],
      createdAt: DateTime(2026, 2, 14),
      isPopular: false,
    ),
    ProductModel(
      id: 'prod_12',
      title: "Gentleman's Desk Set",
      description: 'Handcrafted rosewood pen rest, phone dock, and genuine leather coaster set with gift packaging.',
      price: 3600.0,
      originalPrice: 4200.0,
      imageUrls: ['https://images.unsplash.com/photo-1586075010923-2dd4570fb338?q=80&w=400'],
      categoryId: 'accessories',
      creatorId: 'creator_2',
      creatorName: 'The Candle Corner',
      rating: 4.7,
      reviewCount: 16,
      isCustomizable: false,
      occasions: ['Birthday', 'Graduation', 'Self Care'],
      recipients: ['For Him', 'Partner'],
      interests: ['Gift Box', 'Handmade'],
      createdAt: DateTime(2026, 3, 4),
      isPopular: false,
    ),
  ];
}
