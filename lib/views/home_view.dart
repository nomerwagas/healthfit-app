// lib/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/session_manager.dart';
import '../utils/app_theme.dart';
import '../views/auth/login_view.dart';
import 'profile_view.dart';
import 'widgets/weather_card.dart';
import 'widgets/activity_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final _cityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final userVm = context.read<UserViewModel>();
    await userVm.loadUser(uid);
    final weatherVm = context.read<WeatherViewModel>();
    await weatherVm.initialize();
    if (userVm.user?.city != null && userVm.user!.city!.isNotEmpty) {
      _cityCtrl.text = userVm.user!.city!;
      await weatherVm.fetchWeather(userVm.user!.city!, userVm.user!);
    }
  }

  void _onSessionExpired() {
    context.read<AuthViewModel>().signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginView()), (_) => false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired due to inactivity.')));
  }

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SessionAwareWrapper(
      onSessionExpired: _onSessionExpired,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentIndex == 0 ? 'HEALTHFIT' : 'MY PROFILE'),
          actions: [
            if (_currentIndex == 0)
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  if (_cityCtrl.text.isNotEmpty && userVm.user != null) {
                    weatherVm.fetchWeather(_cityCtrl.text, userVm.user!);
                  }
                },
              ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _DashboardTab(cityCtrl: _cityCtrl),
            const ProfileView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.borderGoldDark
                    : AppColors.borderGoldLight,
                width: 0.8,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'HOME',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'PROFILE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final TextEditingController cityCtrl;
  const _DashboardTab({required this.cityCtrl});

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldDark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedColor =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final pillBg = isDark ? AppColors.black3 : AppColors.lightSurf;
    final pillBorder =
        isDark ? AppColors.borderGoldDark : AppColors.borderGoldLight;

    return RefreshIndicator(
      color: goldColor,
      onRefresh: () async {
        if (cityCtrl.text.isNotEmpty && userVm.user != null) {
          await weatherVm.fetchWeather(cityCtrl.text, userVm.user!);
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Greeting ─────────────────────────────────────────────
                if (userVm.user != null) ...[
                  Text('Good ${_greeting()},',
                      style: TextStyle(
                          color: mutedColor, fontSize: 13, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(
                    userVm.user!.fullName.split(' ').first.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 10),

                  // Profile pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: pillBorder, width: 0.8),
                    ),
                    child: Row(children: [
                      Icon(Icons.person_outline_rounded,
                          size: 14, color: goldColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Age ${userVm.user!.age}  ·  '
                          '${userVm.user!.weight}kg  ·  '
                          '${userVm.user!.weightCategory}  ·  '
                          '${userVm.user!.ageGroup == 'senior' ? 'Senior (50+)' : 'Young (<50)'}',
                          style: TextStyle(
                              color: mutedColor,
                              fontSize: 10,
                              letterSpacing: 0.3),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── City search ───────────────────────────────────────────
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: cityCtrl,
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Enter your city...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (city) {
                        if (userVm.user != null) {
                          weatherVm.fetchWeather(city, userVm.user!);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        if (cityCtrl.text.isNotEmpty && userVm.user != null) {
                          weatherVm.fetchWeather(cityCtrl.text, userVm.user!);
                        }
                      },
                      style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Icon(Icons.cloud_rounded, size: 20),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Error ─────────────────────────────────────────────────
                if (weatherVm.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Text(weatherVm.error!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13)),
                  ),

                // ── Loading ───────────────────────────────────────────────
                if (weatherVm.loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                        child: CircularProgressIndicator(color: goldColor)),
                  ),

                // ── Weather + Activities ──────────────────────────────────
                if (weatherVm.weather != null && !weatherVm.loading) ...[
                  WeatherCard(weather: weatherVm.weather!),
                  const SizedBox(height: 20),
                  Row(children: [
                    Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                            color: goldColor,
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SUGGESTED ACTIVITIES',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                          Text(
                            '${weatherVm.weather!.condition} · '
                            'Age ${userVm.user?.age} · '
                            '${userVm.user?.weightCategory}',
                            style: TextStyle(
                                color: mutedColor,
                                fontSize: 9,
                                letterSpacing: 0.3),
                          ),
                        ]),
                  ]),
                  const SizedBox(height: 12),
                  ...weatherVm.activities.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ActivityCard(activity: a),
                      )),
                ],

                // ── Empty state ───────────────────────────────────────────
                if (weatherVm.weather == null &&
                    !weatherVm.loading &&
                    weatherVm.error == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: pillBorder, width: 0.8),
                          color: pillBg,
                        ),
                        child: Icon(Icons.cloud_outlined,
                            size: 36, color: goldColor),
                      ),
                      const SizedBox(height: 16),
                      Text('Enter your city',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('to get personalized activities',
                          style: TextStyle(color: mutedColor, fontSize: 13)),
                    ]),
                  ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}
