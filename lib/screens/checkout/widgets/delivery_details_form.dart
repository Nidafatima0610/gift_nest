import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/app_text_field.dart';

/// Form component for customer shipping address and delivery note.
class DeliveryDetailsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final TextEditingController noteController;

  const DeliveryDetailsForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.postalCodeController,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.softRoseLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              const Expanded(
                child: Text(
                  'Where should we deliver it?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'We will hand-pack and deliver your gift with care.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: AppDimensions.md),

          // Full Name
          AppTextField(
            key: const Key('checkout_name_field'),
            controller: nameController,
            label: 'Full Name *',
            hintText: 'e.g. Ayesha Khan',
            prefixIcon: const Icon(Icons.person_outline, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.md),

          // Phone Number
          AppTextField(
            key: const Key('checkout_phone_field'),
            controller: phoneController,
            label: 'Phone Number *',
            hintText: 'e.g. 0300 1234567',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a valid phone number';
              }
              if (value.trim().length < 8) {
                return 'Please enter a complete phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.md),

          // Address
          AppTextField(
            key: const Key('checkout_address_field'),
            controller: addressController,
            label: 'Delivery Address *',
            hintText: 'House/Apartment #, Street, Area',
            prefixIcon: const Icon(Icons.home_outlined, size: 20),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the delivery address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.md),

          // City and Postal Code Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  key: const Key('checkout_city_field'),
                  controller: cityController,
                  label: 'City *',
                  hintText: 'e.g. Lahore',
                  prefixIcon: const Icon(Icons.location_city_outlined, size: 20),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter city';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                flex: 2,
                child: AppTextField(
                  key: const Key('checkout_postal_field'),
                  controller: postalCodeController,
                  label: 'Postal Code',
                  hintText: 'e.g. 54000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Delivery Note
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Delivery note (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: noteController,
                    builder: (context, value, _) {
                      return Text(
                        '${value.text.length}/150',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xs + 2),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  key: const Key('checkout_note_field'),
                  controller: noteController,
                  maxLength: 150,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, color: AppColors.mainText),
                  decoration: const InputDecoration(
                    hintText: 'Anything the delivery person should know?',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppDimensions.md),
                    counterText: '',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
