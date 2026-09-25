import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/order_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'widgets/checkout_step_indicator.dart';
import 'widgets/delivery_details_form.dart';
import 'widgets/order_review_card.dart';
import 'widgets/payment_method_card.dart';

/// Checkout Screen (/checkout) managing recipient details, payment method, order review, and order placement.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final existingCart = Provider.of<CartProvider?>(context);
    final existingOrder = Provider.of<OrderProvider?>(context);

    if (existingCart == null || existingOrder == null) {
      return MultiProvider(
        providers: [
          if (existingCart == null) ChangeNotifierProvider(create: (_) => CartProvider()),
          if (existingOrder == null) ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: const _CheckoutScreenContent(),
      );
    }
    return const _CheckoutScreenContent();
  }
}

class _CheckoutScreenContent extends StatefulWidget {
  const _CheckoutScreenContent();

  @override
  State<_CheckoutScreenContent> createState() => _CheckoutScreenContentState();
}

class _CheckoutScreenContentState extends State<_CheckoutScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _noteController;

  // 1 = Details, 2 = Review
  int _currentStep = 1;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _proceedToReview() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _backToDetails() {
    setState(() {
      _currentStep = 1;
    });
  }

  Future<void> _placeOrder() async {
    if (_isPlacingOrder) return;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your gift basket is empty.'),
          backgroundColor: AppColors.error,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.cart);
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final now = DateTime.now();
      final orderId = 'GN-${now.millisecondsSinceEpoch.toString().substring(5)}';

      final newOrder = OrderModel(
        id: orderId,
        items: List.from(cartProvider.items),
        customerName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        deliveryNote: _noteController.text.trim(),
        paymentMethod: 'Cash on Delivery',
        subtotal: cartProvider.subtotal,
        deliveryFee: cartProvider.deliveryFee,
        discount: cartProvider.discount,
        total: cartProvider.total,
        status: 'pending',
        createdAt: now,
      );

      // Persist order in local OrderProvider
      await orderProvider.placeOrder(newOrder);

      // Clear the purchased cart items
      cartProvider.clearCart();

      if (!mounted) return;

      // Navigate to order success
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.orderSuccess,
        arguments: newOrder,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not place order: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // If cart is completely empty and not placing order
        if (cartProvider.items.isEmpty && !_isPlacingOrder) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Checkout'),
            ),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: EmptyState(
                    icon: Icons.shopping_basket_outlined,
                    title: 'Your basket is empty',
                    description:
                        'Add some thoughtful gifts to your basket before checking out.',
                    buttonText: 'Explore Gifts',
                    onButtonPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.explore);
                    },
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Checkout'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_currentStep == 2) {
                  _backToDetails();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Step Indicator (1. Basket, 2. Details, 3. Review)
                CheckoutStepIndicator(
                  currentStep: _currentStep,
                  onStepTapped: (stepIndex) {
                    if (stepIndex == 0) {
                      Navigator.pop(context);
                    } else if (stepIndex == 1 && _currentStep == 2) {
                      _backToDetails();
                    }
                  },
                ),

                // Main Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                      vertical: AppDimensions.md,
                    ),
                    child: _currentStep == 1
                        ? _buildDetailsStep()
                        : _buildReviewStep(cartProvider),
                  ),
                ),

                // Bottom Action Bar
                _buildBottomBar(cartProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeliveryDetailsForm(
          formKey: _formKey,
          nameController: _nameController,
          phoneController: _phoneController,
          addressController: _addressController,
          cityController: _cityController,
          postalCodeController: _postalCodeController,
          noteController: _noteController,
        ),
        const SizedBox(height: AppDimensions.lg),
        const PaymentMethodCard(),
        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  Widget _buildReviewStep(CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderReviewCard(
          items: cartProvider.items,
          customerName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          deliveryNote: _noteController.text.trim(),
          subtotal: cartProvider.subtotal,
          deliveryFee: cartProvider.deliveryFee,
          discount: cartProvider.discount,
          total: cartProvider.total,
          onEditDetails: _backToDetails,
        ),
        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Total',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    'PKR ${cartProvider.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _currentStep == 1
                    ? AppButton(
                        key: const Key('checkout_continue_button'),
                        text: 'Continue to Review',
                        icon: Icons.arrow_forward,
                        onPressed: _proceedToReview,
                      )
                    : AppButton(
                        key: const Key('checkout_place_order_button'),
                        text: 'Place Order',
                        icon: Icons.check_circle_outline,
                        isLoading: _isPlacingOrder,
                        onPressed: _placeOrder,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
