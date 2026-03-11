import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_cart_rounded),
        title: Text('Shop Module'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search",
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Symbols.filter_list),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  shopCard("Dumbbell"),
                  shopCard("Yoga Mat"),
                  shopCard("Resistance Band"),
                  shopCard("Protein Bottle"),
                  shopCard("Punching Bag"),
                  shopCard("Gym Gloves"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shopCard(String itemName) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(itemName, style: Theme.of(context).textTheme.bodyMedium),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              child: Text("Add to cart"),
            ),
          ],
        ),
      ),
    );
  }
}
