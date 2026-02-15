import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialLocation;

  const EditProfileScreen({
    super.key,
    this.initialName = '',
    this.initialEmail = '',
    this.initialPhone = '',
    this.initialLocation = '',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  // Country Codes List
  final List<Map<String, String>> _countryCodes = [
    {'code': '+92', 'name': 'PK', 'flag': '🇵🇰', 'example': '312 3456789'},
    {'code': '+1', 'name': 'US', 'flag': '🇺🇸', 'example': '202 555 0123'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧', 'example': '7700 900077'},
    {'code': '+91', 'name': 'IN', 'flag': '🇮🇳', 'example': '98765 43210'},
    {'code': '+86', 'name': 'CN', 'flag': '🇨🇳', 'example': '139 1234 5678'},
    {'code': '+971', 'name': 'AE', 'flag': '🇦🇪', 'example': '50 123 4567'},
    {'code': '+966', 'name': 'SA', 'flag': '🇸🇦', 'example': '50 123 4567'},
    {'code': '+61', 'name': 'AU', 'flag': '🇦🇺', 'example': '412 345 678'},
    {'code': '+1', 'name': 'CA', 'flag': '🇨🇦', 'example': '416 555 0123'},
    {'code': '+49', 'name': 'DE', 'flag': '🇩🇪', 'example': '151 23456789'},
    {'code': '+33', 'name': 'FR', 'flag': '🇫🇷', 'example': '6 12 34 56 78'},
    {'code': '+81', 'name': 'JP', 'flag': '🇯🇵', 'example': '90 1234 5678'},
    {'code': '+90', 'name': 'TR', 'flag': '🇹🇷', 'example': '501 234 5678'},
    {'code': '+98', 'name': 'IR', 'flag': '🇮🇷', 'example': '912 345 6789'},
    {'code': '+93', 'name': 'AF', 'flag': '🇦🇫', 'example': '70 123 4567'},
    {'code': '+880', 'name': 'BD', 'flag': '🇧🇩', 'example': '1712 345678'},
    {'code': '+62', 'name': 'ID', 'flag': '🇮🇩', 'example': '812 3456 7890'},
    {'code': '+60', 'name': 'MY', 'flag': '🇲🇾', 'example': '12 345 6789'},
    {'code': '+94', 'name': 'LK', 'flag': '🇱🇰', 'example': '77 123 4567'},
    {'code': '+977', 'name': 'NP', 'flag': '🇳🇵', 'example': '9841 234567'},
    {'code': '+39', 'name': 'IT', 'flag': '🇮🇹', 'example': '320 123 4567'},
    {'code': '+34', 'name': 'ES', 'flag': '🇪🇸', 'example': '612 34 56 78'},
    {'code': '+7', 'name': 'RU', 'flag': '🇷🇺', 'example': '912 345-67-89'},
    {'code': '+55', 'name': 'BR', 'flag': '🇧🇷', 'example': '11 91234-5678'},
    {'code': '+27', 'name': 'ZA', 'flag': '🇿🇦', 'example': '72 123 4567'},
  ];

  String _selectedCountryIso = 'PK';

  @override
  void initState() {
    super.initState();
    // Initialize with passed data
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _locationController = TextEditingController(text: widget.initialLocation);

    // Parse Phone Number
    String phone = widget.initialPhone;
    String matchedIso = 'PK';
    String numberPart = phone;

    // Try to match with existing codes - finding longest match first
    var sortedCodes = List<Map<String, String>>.from(_countryCodes);
    sortedCodes.sort((a, b) => b['code']!.length.compareTo(a['code']!.length));

    for (var country in sortedCodes) {
      String code = country['code']!;
      if (phone.startsWith(code)) {
        matchedIso = country['name']!;
        numberPart = phone.substring(code.length).trim();
        break;
      }
    }
    _selectedCountryIso = matchedIso;
    _phoneController = TextEditingController(text: numberPart);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTextField(
                      "Full Name",
                      _nameController,
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      "Email",
                      _emailController,
                      Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildPhoneField(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      "Location",
                      _locationController,
                      Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Find selected country code
                                  final selectedCountry = _countryCodes
                                      .firstWhere(
                                        (c) => c['name'] == _selectedCountryIso,
                                        orElse: () => _countryCodes[0],
                                      );
                                  final code = selectedCountry['code'];

                                  Navigator.pop(context, {
                                    'name': _nameController.text,
                                    'email': _emailController.text,
                                    'phone': '$code ${_phoneController.text}',
                                    'location': _locationController.text,
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Profile Updated Successfully!",
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Edit Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Travel Background Image (same as profile)
            Image.asset(
              'assets/images/pakistan_flag_bg.png',
              fit: BoxFit.cover,
            ),
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Hero(
                          tag: 'profile_image',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780&auto=format&fit=crop',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "Phone Number",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Country Code Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryIso,
                    menuMaxHeight: 300,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                    ),
                    items: _countryCodes.map((Map<String, String> country) {
                      return DropdownMenuItem<String>(
                        value: country['name'],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country['flag']!,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              country['code']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountryIso = newValue!;
                      });
                    },
                  ),
                ),
              ),
              // Phone Input
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    hintText: _countryCodes.firstWhere(
                      (c) => c['name'] == _selectedCountryIso,
                      orElse: () => _countryCodes[0],
                    )['example'],
                    hintStyle: TextStyle(
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (!RegExp(r'^[0-9\s]+$').hasMatch(value)) {
                      return 'Please enter valid digits';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withValues(alpha: 0.5),
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1, end: 0);
  }
}
