import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ExitDialog extends StatelessWidget {
  final String packageName;
  final String? developerId;

  const ExitDialog({
    super.key,
    required this.packageName,
    this.developerId,
  });

  Future<void> _launchStore(Uri url, Uri webUrl) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('URL 실행 오류: $e');
    }
  }

  Widget _buildExitButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDestructive
                    ? Colors.red.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDestructive ? Colors.red : Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Icon(
            Icons.waving_hand,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          const Text(
            '안녕히 가세요!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '다음에 또 만나요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _buildExitButton(
              context: context,
              icon: Icons.star,
              title: '앱 평가하기',
              subtitle: '소중한 의견을 들려주세요',
              onTap: () {
                final url = Uri.parse(
                    'market://details?id=$packageName&showAllReviews=true'
                );
                final webUrl = Uri.parse(
                    'https://play.google.com/store/apps/details?id=$packageName&showAllReviews=true'
                );
                _launchStore(url, webUrl);
              },
            ),
            if (developerId != null)
              _buildExitButton(
                context: context,
                icon: Icons.apps_rounded,
                title: '다른 앱 보기',
                subtitle: '더 많은 앱을 만나보세요',
                onTap: () {
                  final url = Uri.parse('market://dev?id=$developerId');
                  final webUrl = Uri.parse(
                      'https://play.google.com/store/apps/dev?id=$developerId'
                  );
                  _launchStore(url, webUrl);
                },
              ),
            _buildExitButton(
              context: context,
              icon: Icons.exit_to_app,
              title: '앱 종료하기',
              subtitle: '다음에 또 만나요',
              onTap: () => SystemNavigator.pop(),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}