import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as ap;
import '../../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize from auth provider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = context.read<ap.AuthProvider>().userProfile;
      setState(() {
        _notificationsEnabled = profile?.notificationsEnabled ?? true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your preferences',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Builder(
      builder: (ctx) => Consumer<ap.AuthProvider>(
        builder: (_, auth, __) {
          final profile = auth.userProfile;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF2C5364),
                        child: Text(
                          (profile?.displayName ?? auth.user?.email ?? 'U')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.displayName ?? 'User',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile?.email ?? auth.user?.email ?? '',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Email Verified',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Profile UID card (separate)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile UID',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.user?.uid ?? '',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Preferences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Notifications toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SwitchListTile(
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      // Update local state immediately for responsiveness
                      setState(() {
                        _notificationsEnabled = value;
                      });

                      await ctx
                          .read<ap.AuthProvider>()
                          .updateNotifications(value);
                      if (ctx.mounted) {
                        if (value) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              duration: const Duration(seconds: 3),
                              content: Text(
                                'Location notification enabled! You\'ll be getting notified about nearby services.',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                'Location notification disabled.',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    title: const Text(
                      'Location Notifications',
                      style: TextStyle(color: Colors.black87),
                    ),
                    subtitle: const Text(
                      'Get notified about services near you',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Color(0xFF2C5364), size: 20),
                    ),
                    activeColor: const Color(0xFF2C5364),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.info_outline,
                              color: AppColors.primary, size: 20),
                        ),
                        title: const Text('Version',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14)),
                        trailing: const Text('1.0.0',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_city_outlined,
                              color: AppColors.primary, size: 20),
                        ),
                        title: const Text('App',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14)),
                        trailing: const Text('Kigali City Services Directory',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: ctx,
                        builder: (dialogCtx) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Sign Out',
                              style: TextStyle(color: Colors.black87)),
                          content: const Text(
                            'Are you sure you want to sign out?',
                            style: TextStyle(color: Colors.black54),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogCtx, false),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.black54)),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(dialogCtx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C5364),
                              ),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && ctx.mounted) {
                        await ctx.read<ap.AuthProvider>().signOut();
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Sign Out',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
