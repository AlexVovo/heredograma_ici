import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import 'heredogramas_list_view.dart';
import 'home_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const HeredogramasListView(),
    const _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          final extended = constraints.maxWidth >= 1180;
          return Scaffold(
            body: Row(
              children: [
                _DesktopSidebar(
                  selectedIndex: _index,
                  extended: extended,
                  onSelected: _selectPage,
                ),
                Expanded(child: _pages[_index]),
              ],
            ),
          );
        }

        return Scaffold(
          body: _pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _selectPage,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_tree_outlined),
                selectedIcon: Icon(Icons.account_tree_rounded),
                label: 'Heredogramas',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectPage(int value) => setState(() => _index = value);
}

class _DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final bool extended;
  final ValueChanged<int> onSelected;

  const _DesktopSidebar({
    required this.selectedIndex,
    required this.extended,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final width = extended ? 264.0 : 88.0;
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          _BrandHeader(extended: extended),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                extended ? 16 : 12,
                24,
                extended ? 16 : 12,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (extended) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                      child: Text(
                        'NAVEGAÇÃO',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ],
                  _SidebarDestination(
                    icon: Icons.home_rounded,
                    label: 'Início',
                    selected: selectedIndex == 0,
                    extended: extended,
                    onTap: () => onSelected(0),
                  ),
                  const SizedBox(height: 6),
                  _SidebarDestination(
                    icon: Icons.account_tree_rounded,
                    label: 'Heredogramas',
                    selected: selectedIndex == 1,
                    extended: extended,
                    onTap: () => onSelected(1),
                  ),
                  const SizedBox(height: 6),
                  _SidebarDestination(
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    selected: selectedIndex == 2,
                    extended: extended,
                    onTap: () => onSelected(2),
                  ),
                  const Spacer(),
                  if (extended)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.health_and_safety_outlined,
                                size: 18,
                                color: AppTheme.accent,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'HeredoOnco',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Mapeie histórias. Entenda gerações.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 10,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool extended;

  const _BrandHeader({required this.extended});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: extended ? 18 : 17),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B2F55), Color(0xFF145D72)],
        ),
      ),
      child: Row(
        mainAxisAlignment:
            extended ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .16),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const BrandLogo.compact(),
          ),
          if (extended) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HeredoOnco',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'GENÉTICA  •  CUIDADO',
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFFB7E1E3),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  const _SidebarDestination({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFF475569);
    return Tooltip(
      message: extended ? '' : label,
      child: Material(
        color: selected ? AppTheme.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          hoverColor: AppTheme.primarySoft.withValues(alpha: .55),
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: extended ? 14 : 0),
            child: Row(
              mainAxisAlignment:
                  extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(icon, color: foreground, size: 21),
                if (extended) ...[
                  const SizedBox(width: 13),
                  Text(
                    label,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo(width: 180),
            SizedBox(height: 16),
            Text('Perfil (em breve)'),
          ],
        ),
      ),
    );
  }
}
