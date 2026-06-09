import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkPaletteForced = true;
  bool _styleChipsModified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      'System Account\nSettings',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: AppColors.textMuted),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Profile card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E2060), Color(0xFF0F0F1A)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            child: const Text('AM', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.dark, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amara Mwangi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            Text('amara@email.com', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            SizedBox(height: 6),
                            _StyleBadge(label: 'Afro-Chic', emoji: '🌍'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: const Text('Edit', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats row
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _StatCard(label: 'Items', value: '24', icon: Icons.checkroom_outlined),
                    SizedBox(width: 12),
                    _StatCard(label: 'Outfits', value: '38', icon: Icons.style_outlined),
                    SizedBox(width: 12),
                    _StatCard(label: 'Days Logged', value: '52', icon: Icons.calendar_today_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings sections
              _SettingsSection(
                title: 'User Profile Node',
                icon: Icons.person_outline,
                color: AppColors.primary,
                children: [
                  _SettingsTile(label: 'Edit Profile', onTap: () {}),
                  _SettingsTile(label: 'Body Type Profile', badge: 'Hourglass', onTap: () {}),
                  _SettingsTile(label: 'Style Preferences', onTap: () {}),
                  _SettingsTile(label: 'Location Settings', badge: 'Nairobi, KE', onTap: () {}),
                ],
              ),

              const SizedBox(height: 12),

              _SettingsSection(
                title: 'Modify Style Chips Layout',
                icon: Icons.tune_outlined,
                color: AppColors.accent,
                children: [
                  _SettingsTile(
                    label: 'Custom Style Tags',
                    onTap: () {},
                    trailing: Switch(
                      value: _styleChipsModified,
                      onChanged: (v) => setState(() => _styleChipsModified = v),
                      activeColor: AppColors.accent,
                    ),
                  ),
                  _SettingsTile(label: 'AI Style Sensitivity', badge: 'High', onTap: () {}),
                  _SettingsTile(label: 'Trend Region Focus', badge: 'Nairobi + Global', onTap: () {}),
                ],
              ),

              const SizedBox(height: 12),

              _SettingsSection(
                title: 'Force Dark Palette Engine',
                icon: Icons.dark_mode_outlined,
                color: const Color(0xFF8B5CF6),
                children: [
                  _SettingsTile(
                    label: 'Dark Mode',
                    trailing: Switch(
                      value: _darkPaletteForced,
                      onChanged: (v) => setState(() => _darkPaletteForced = v),
                      activeColor: const Color(0xFF8B5CF6),
                    ),
                    onTap: () => setState(() => _darkPaletteForced = !_darkPaletteForced),
                  ),
                  _SettingsTile(label: 'Color Accent', badge: 'Indigo Blue', onTap: () {}),
                  _SettingsTile(label: 'Font Style', badge: 'Poppins', onTap: () {}),
                ],
              ),

              const SizedBox(height: 12),

              _SettingsSection(
                title: 'Data & Privacy',
                icon: Icons.security_outlined,
                color: AppColors.success,
                children: [
                  _SettingsTile(label: 'Export Wardrobe Data', onTap: () {}),
                  _SettingsTile(label: 'Delete Account', isDestructive: true, onTap: () {}),
                ],
              ),

              const SizedBox(height: 32),

              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/onboarding'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleBadge extends StatelessWidget {
  final String label, emoji;
  const _StyleBadge({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.icon, required this.color, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 10),
                  Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            ...children.map((c) => Column(
              children: [
                const Divider(color: Color(0xFF2A2A4A), height: 1),
                c,
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final String? badge;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isDestructive;
  const _SettingsTile({required this.label, this.badge, this.trailing, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            if (badge != null) ...[
              Text(badge!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(width: 8),
            ],
            trailing ?? Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red.withOpacity(0.5) : AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
