import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../managers/userManager.dart';


class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerWidgetState ();

}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {

   @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                    child: SizedBox(
                      width: 1500,
                      height: 100,
                      child: Image.asset("assets/appLogo/logo.jpg"),
                    )
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text("S T O C K S"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.wallet,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text("W A L L E T"),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context,"/wallet");
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.wallet,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                title: const Text("L O G O U T"),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(userManager.notifier).logOut();
                  Navigator.pushReplacementNamed(context,"/");
                },
              ),
            )
          ],
        )
    );
  }

}