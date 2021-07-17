import 'package:cala/widgets/contents/MainPageContent.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/configs/CalaIcons.dart';

class CalaMainPage extends StatelessWidget {
  var mainPageContent = MainPageContent();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cala'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      drawer: _CalaDrawer(),
      body: mainPageContent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('ADD BUTTON PRESSED'),
        child: CalaIcons.addIcon,
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _CalaDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _CalaDrawerHeader(),
          ListTile(
            leading: CalaIcons.histIcon,
            title: Text('Historial de Comidas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/historial');
            },
          ),
          ListTile(
            leading: CalaIcons.catalogIcon,
            title: Text('Catalogo de Comidas'),
            onTap: () => Navigator.pushNamed(context, '/catalogo'),
          ),
          ListTile(
            leading: CalaIcons.progressIcon,
            title: Text('Mi Progreso'),
            onTap: () => Navigator.pushNamed(context, '/progreso'),
          ),
          ListTile(
            leading: CalaIcons.objetivIcon,
            title: Text('Mis Objetivos'),
            onTap: () => Navigator.pushNamed(context, '/objetivos'),
          ),
          ListTile(
            leading: CalaIcons.salirIcon,
            title: Text('Salir'),
            onTap: () => print('Salir'),
          ),
        ],
      ),
    );
  }
}

class _CalaDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: CalaColors.gradientBoxDecoration,
      child: Text(
        'Drawer Header',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }
}
