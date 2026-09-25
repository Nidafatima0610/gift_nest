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
      description: 'Handcrafted ceramic mug with custom calligraphy name and 24k gold luster rim. Made with stoneware clay and glazed in small batches for lasting beauty.',
      price: 1450.0,
      originalPrice: 1750.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=600',
        'https://images.unsplash.com/photo-1577937927133-66ef06acdf18?q=80&w=600',
      ],
      categoryId: 'home_living',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.9,
      reviewCount: 38,
      isCustomizable: true,
      customizableFields: ['Name', 'Color', 'Message'],
      occasions: ['Birthday', 'Anniversary'],
      recipients: ['For Her', 'For Him', 'Friends'],
      interests: ['Personalized'],
      createdAt: DateTime(2026, 3, 1),
      isPopular: true,
      material: 'Handmade Glazed Ceramic & 24k Gold Luster',
      size: '350 ml (12 oz)',
      color: 'Pastel Blush',
      preparationTime: '2 business days',
      availableColors: ['Blush Rose', 'Cloud White', 'Sage Green', 'Plum Bloom'],
      personalizationPrice: 250.0,
    ),
    ProductModel(
      id: 'prod_2',
      title: 'Custom Photo Frame',
      description: 'Solid walnut wooden frame with personalized engraved message and archival matte print. Features museum-grade anti-reflective glass.',
      price: 2800.0,
      originalPrice: 3200.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600',
        'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=600',
      ],
      categoryId: 'keepsakes',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 5.0,
      reviewCount: 52,
      isCustomizable: true,
      customizableFields: ['Photo', 'Message', 'Color'],
      occasions: ['Anniversary', 'Wedding'],
      recipients: ['Partner', 'Parents'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 5),
      isPopular: true,
      material: 'Solid Walnut Wood & Crystal Glass',
      size: '6 x 8 inches',
      preparationTime: '3 business days',
      availableColors: ['Dark Walnut', 'Natural Oak', 'Warm Honey'],
      personalizationPrice: 350.0,
    ),
    ProductModel(
      id: 'prod_3',
      title: 'Mini Self-Care Box',
      description: 'Aromatherapy bath salts, organic lip scrub, and hand-poured lavender soy candle presented in an embossed satin-ribbon keepsake gift box.',
      price: 3950.0,
      originalPrice: 4500.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?q=80&w=600',
      ],
      categoryId: 'care_packages',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 4.8,
      reviewCount: 29,
      isCustomizable: true,
      customizableFields: ['Message'],
      occasions: ['Birthday', 'Self Care'],
      recipients: ['For Her', 'Friends'],
      interests: ['Gift Box', 'Self Care'],
      createdAt: DateTime(2026, 2, 20),
      isPopular: true,
      material: 'Organic Botanical Salts, Lip Scrub & Soy Wax',
      size: 'Medium Gift Box (8 x 8 x 4 in)',
      preparationTime: '1 business day',
      personalizationPrice: 150.0,
    ),
    ProductModel(
      id: 'prod_4',
      title: 'Handmade Bracelet',
      description: 'Delicate freshwater pearl and rose gold plated charm bracelet with custom initial charm. Crafted with hypoallergenic jeweler wire.',
      price: 1850.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1611591475816-a794b6ecffba?q=80&w=600',
      ],
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
      material: 'Freshwater Pearls & 18k Rose Gold Plating',
      size: 'Adjustable 6.5–8.0 in',
      preparationTime: '1 business day',
    ),
    ProductModel(
      id: 'prod_5',
      title: 'Personalized Journal',
      description: 'Full-grain vintage brown leather notebook with refillable parchment paper and initials. Hand-stitched with durable waxed linen thread.',
      price: 2400.0,
      originalPrice: 2800.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=600',
      ],
      categoryId: 'stationery',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 4.7,
      reviewCount: 19,
      isCustomizable: true,
      customizableFields: ['Name', 'Message', 'Color'],
      occasions: ['Graduation', 'Eid', 'Handmade'],
      recipients: ['For Him', 'For Her', 'Friends'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 8),
      isPopular: true,
      material: 'Full Grain Buffed Leather & Handmade Cotton Rag Paper',
      size: 'A5 (5.8 x 8.3 in)',
      preparationTime: '2 business days',
      availableColors: ['Vintage Brown', 'Midnight Plum', 'Classic Tan'],
      personalizationPrice: 300.0,
    ),
    ProductModel(
      id: 'prod_6',
      title: 'Scented Candle Set',
      description: 'Trio of hand-poured soy wax candles: Oud & Rose, Vanilla Amber, and Jasmine Breeze in frosted amber glass vessels.',
      price: 2650.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b8?q=80&w=600',
      ],
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
      material: '100% Organic Soy Wax & Botanical Essential Oils',
      size: 'Set of 3 (70g each)',
      preparationTime: '1 business day',
    ),
    ProductModel(
      id: 'prod_7',
      title: 'Custom Keychain',
      description: 'Handcrafted leather and brass engraved keychain with custom name stamp. Polished with organic beeswax for longevity.',
      price: 850.0,
      originalPrice: 1100.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?q=80&w=600',
      ],
      categoryId: 'accessories',
      creatorId: 'creator_1',
      creatorName: "Sana's Studio",
      rating: 4.8,
      reviewCount: 31,
      isCustomizable: true,
      customizableFields: ['Name', 'Color'],
      occasions: ['Birthday', 'Graduation', 'Handmade'],
      recipients: ['For Him', 'Friends', 'Partner'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 12),
      isPopular: false,
      material: 'Solid Brass & Veg-Tanned Cowhide Leather',
      size: '10 x 2.5 cm',
      preparationTime: '1 business day',
      availableColors: ['Chestnut Brown', 'Onyx Black', 'Caramel Tan'],
      personalizationPrice: 150.0,
    ),
    ProductModel(
      id: 'prod_8',
      title: 'Eid Gift Hamper',
      description: 'Deluxe celebration basket with gourmet baklava, royal amber perfume, and brass crescent tray adorned with dried jasmine blooms.',
      price: 5400.0,
      originalPrice: 6200.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=600',
      ],
      categoryId: 'care_packages',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 5.0,
      reviewCount: 41,
      isCustomizable: true,
      customizableFields: ['Name', 'Message'],
      occasions: ['Eid'],
      recipients: ['Parents', 'Friends', 'Partner'],
      interests: ['Gift Box'],
      createdAt: DateTime(2026, 3, 15),
      isPopular: true,
      material: 'Brass Crescent Tray, Hand-Rolled Baklava & Royal Amber Attar',
      size: 'Deluxe Hamper Box (12 x 12 x 5 in)',
      preparationTime: '2 business days',
      personalizationPrice: 300.0,
    ),
    ProductModel(
      id: 'prod_9',
      title: 'Minimal Jewelry Box',
      description: 'Velvet-lined wooden trinket box with delicate brass inlay and hand-carved floral latch. Ideal for keepsakes and rings.',
      price: 2200.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=600',
      ],
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
      material: 'Teak Wood, Brass Inlay & Velvet Lining',
      size: '7 x 5 x 3.5 inches',
      preparationTime: '2 business days',
    ),
    ProductModel(
      id: 'prod_10',
      title: 'Memory Scrapbook',
      description: 'Hardbound vintage scrapbook with handmade kraft pages, corner stickers, and gold pen for preserving cherished memories.',
      price: 3200.0,
      originalPrice: 3800.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=600',
      ],
      categoryId: 'stationery',
      creatorId: 'creator_3',
      creatorName: 'Crafted by Noor',
      rating: 4.8,
      reviewCount: 35,
      isCustomizable: true,
      customizableFields: ['Name', 'Message'],
      occasions: ['Anniversary', 'Wedding', 'Handmade'],
      recipients: ['Partner', 'Friends'],
      interests: ['Personalized', 'Handmade'],
      createdAt: DateTime(2026, 3, 2),
      isPopular: true,
      material: 'Hardcover Kraft Board, Acid-Free Handmade Sheets',
      size: '10 x 10 inches (40 pages)',
      preparationTime: '3 business days',
      personalizationPrice: 350.0,
    ),
    ProductModel(
      id: 'prod_11',
      title: 'New Baby Welcome Keepsake',
      description: 'Hand-painted wooden birth announcement plaque with baby name, date, weight, and milestone cards.',
      price: 4200.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1519689680058-324335c77eba?q=80&w=600',
      ],
      categoryId: 'keepsakes',
      creatorId: 'creator_4',
      creatorName: 'Little Things PK',
      rating: 5.0,
      reviewCount: 18,
      isCustomizable: true,
      customizableFields: ['Name', 'Message', 'Color'],
      occasions: ['New Baby'],
      recipients: ['Parents', 'Kids'],
      interests: ['Gift Box', 'Personalized'],
      createdAt: DateTime(2026, 2, 14),
      isPopular: false,
      material: 'Natural Pine Wood with Non-Toxic Pastel Acrylic Paint',
      size: '8 x 8 x 3 inches',
      preparationTime: '3 business days',
      availableColors: ['Baby Blue', 'Blush Pink', 'Mint Green', 'Ivory Cream'],
      personalizationPrice: 400.0,
    ),
    ProductModel(
      id: 'prod_12',
      title: "Gentleman's Desk Set",
      description: 'Handcrafted rosewood pen rest, phone dock, and genuine leather coaster set with signature gift packaging.',
      price: 3600.0,
      originalPrice: 4200.0,
      imageUrls: [
        'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?q=80&w=600',
      ],
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
      material: 'Solid Sheesham Rosewood & Full-Grain Leather',
      size: 'Dock (8 x 4 in), Coasters (4 in set of 4)',
      preparationTime: '2 business days',
    ),
  ];
}
