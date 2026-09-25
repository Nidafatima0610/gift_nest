import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/build_gift/build_gift_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/gift_finder/gift_finder_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/orders/orders_screen.dart';
import '../../screens/product_details/product_details_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/splash_screen.dart';

/// Central named routes configuration for Gift Nest.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String giftFinder = '/gift-finder';
  static const String productDetails = '/product-details';
  static const String buildGift = '/build-gift';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      case onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case signup:
        return _buildRoute(const SignupScreen(), settings);
      case home:
        return _buildRoute(const HomeScreen(), settings);
      case explore:
        return _buildRoute(const ExploreScreen(), settings);
      case giftFinder:
        return _buildRoute(const GiftFinderScreen(), settings);
      case productDetails:
        return _buildRoute(const ProductDetailsScreen(), settings);
      case buildGift:
        return _buildRoute(const BuildGiftScreen(), settings);
      case favorites:
        return _buildRoute(const FavoritesScreen(), settings);
      case cart:
        return _buildRoute(const CartScreen(), settings);
      case checkout:
        return _buildRoute(const CheckoutScreen(), settings);
      case orders:
        return _buildRoute(const OrdersScreen(), settings);
      case profile:
        return _buildRoute(const ProfileScreen(), settings);
      default:
        return _buildRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
    );
  }
}
