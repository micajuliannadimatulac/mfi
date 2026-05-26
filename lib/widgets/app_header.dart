import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            child: Image.asset(
              AppAssets.logo,
              width: 78,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mahintana Foundation, Inc.',
            textAlign: TextAlign.center,
            style: AppText.calSans(
              fontSize: 20,
              color: AppColors.blue,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '“Building Resiliency, Sustaining Development”',
            textAlign: TextAlign.center,
            style: AppText.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
