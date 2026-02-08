import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'my_trips_screen.dart';
import 'travel_guide_screen.dart';
import 'settings_screen.dart';
import 'change_password_screen.dart';
import 'privacy_security_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import '../core/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Data State
  String _name = "Khuzaim Sajjad";
  String _email = "khuzaim.sajjad@example.com";
  String _phone = "+92 312 3456789";
  String _location = "Multan, Pakistan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildSectionHeader("Account"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildSettingsItem(
                      Icons.person_outline,
                      "Edit Profile",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              initialName: _name,
                              initialEmail: _email,
                              initialPhone: _phone,
                              initialLocation: _location,
                            ),
                          ),
                        );

                        if (result != null && result is Map) {
                          setState(() {
                            _name = result['name'] ?? _name;
                            _email = result['email'] ?? _email;
                            _phone = result['phone'] ?? _phone;
                            _location = result['location'] ?? _location;
                          });
                        }
                      },
                    ),
                    _buildSettingsItem(
                      Icons.lock_outline,
                      "Change Password",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      Icons.privacy_tip_outlined,
                      "Privacy & Security",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacySecurityScreen(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionHeader("My Travel"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildSettingsItem(
                      Icons.confirmation_number_outlined,
                      "My Trips",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyTripsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      Icons.menu_book_outlined,
                      "Travel Guide",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TravelGuideScreen(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionHeader("Preferences"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildSettingsItem(
                      Icons.settings_outlined,
                      "Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionHeader("Community"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildSettingsItem(
                      Icons.person_add_outlined,
                      "Invite Friends",
                      onTap: () {
                        SharePlus.instance.share(
                          ShareParams(
                            text: 'Check out this amazing travel app - Travio!',
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionHeader("Support"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildSettingsItem(
                      Icons.help_outline,
                      "Help & Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsItem(Icons.info_outline, "About App"),
                  ]),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.2),
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded),
                            const SizedBox(width: 12),
                            const Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.white),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(
                  initialName: _name,
                  initialEmail: _email,
                  initialPhone: _phone,
                  initialLocation: _location,
                ),
              ),
            );

            if (result != null && result is Map) {
              setState(() {
                _name = result['name'] ?? _name;
                _email = result['email'] ?? _email;
                _phone = result['phone'] ?? _phone;
                _location = result['location'] ?? _location;
              });
            }
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Travel Background Image
            Image.asset('assets/images/pakistan_map_bg.png', fit: BoxFit.cover),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            // Abstract Pattern (Subtle)
            Positioned(
              left: -50,
              bottom: 20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Profile Info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: 'profile_image',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780&auto=format&fit=crop',
                        ),
                      ),
                    ),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 16),
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 4),
                Text(
                  _phone,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _location,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("24", "Trips"),
          _buildVerticalDivider(),
          _buildStatItem("18", "Reviews"),
          _buildVerticalDivider(),
          _buildStatItem("56", "Saved"),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: List.generate(items.length, (index) {
            return Column(
              children: [
                items[index],
                if (index < items.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 16),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap ?? () {},
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
