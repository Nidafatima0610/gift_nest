import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

/// Screen displaying user's placed gift orders (/orders).
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final existingOrder = Provider.of<OrderProvider?>(context);
    if (existingOrder == null) {
      return ChangeNotifierProvider(
        create: (_) => OrderProvider(),
        child: const _OrdersContent(),
      );
    }
    return const _OrdersContent();
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            if (orderProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final orders = orderProvider.orders;

            if (orders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  children: [
                    Expanded(
                      child: EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No orders yet 🎁',
                        description:
                            'When you place a gift order, you\'ll see packaging status, recipient delivery details, and order tracking here.',
                        buttonText: 'Start Gifting',
                        onButtonPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.explore);
                        },
                      ),
                    ),
                    AppButton(
                      text: 'Back to Home',
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.md),
              itemCount: orders.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.md),
              itemBuilder: (context, index) {
                if (index == orders.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                    child: AppButton(
                      text: 'Find More Gifts',
                      variant: AppButtonVariant.outline,
                      icon: Icons.card_giftcard,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.explore);
                      },
                    ),
                  );
                }

                final order = orders[index];
                return _buildOrderCard(context, order);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final dateStr =
        '${_monthName(order.createdAt.month)} ${order.createdAt.day}, ${order.createdAt.year}';

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID & Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mainText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softRoseLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(color: AppColors.softRose),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppDimensions.sm),

          // Items summary
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                children: [
                  Icon(
                    item.isGiftBox ? Icons.card_giftcard : Icons.circle,
                    size: item.isGiftBox ? 16 : 8,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.isGiftBox
                          ? 'Custom Gift Box (${item.giftBox?.items.length ?? 0} gifts • ${item.giftBox?.packagingStyle ?? "Classic"})'
                          : '${item.product.title} (x${item.quantity})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mainText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PKR ${item.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.sm),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppDimensions.sm),

          // Delivery & Payment info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivering to ${order.customerName}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${order.city} • ${order.paymentMethod}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    'PKR ${order.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
