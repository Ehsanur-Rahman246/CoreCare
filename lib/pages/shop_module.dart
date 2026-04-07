import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final Map<String, List<String>> items1n = {
    'equipN' : ['2kg Dumbbells',
      'Resistance Bands Set',
      'Basic Yoga Mat',
      'Foam Roller 30cm',
      'Jump Rope',
      'Mini Stability Ball',
      'Kettlebell 4kg',
      'Hand Grip Strengthener',
    ],
    'equipP' : ["Adjustable Dumbbells 2-12 kg", 'Premium Yoga Mat (Eco Friendly)', 'Heavy-Duty Kettlebell 8kg', 'Vibrating Massage Gun', 'Professional Foam Roller', 'Smart Jump Rope', 'Large Stability Ball',],
    'accN' : ['Water Bottle 500ml', 'Sweat Towel', 'Wristbands', 'Gym bag Small', 'Yoga Socks', 'Knee Support', 'Elbow Support'],
    'accP' : ['Smart Water Bottle', 'Large Gym Bag', 'Sleep Mask Memory Foam', 'Meditation Cushion', 'Acupressure Mat', 'Hot/Cold Pack Gel', 'Fitness Tracker', 'Smartwatch'],
    'vegN' : ['Apples', 'Bananas', 'Carrots', 'Tomatoes', 'Spinach', 'Broccoli', 'Cucumbers'],
    'vegP' : ['Organic Berries  Mix', 'Organic Kale', 'Avocado', 'Exotic Mushrooms', 'Heirloom Tomatoes', 'Organic Bell Peppers', 'Organic Baby Spinach', 'Imported Citrus Mix'],
    'groceryN': ['White Rice', 'Whole Wheat Pasta',]
  };

  int filter = 0;
  final List<String> filterLabels = [
    'All', 'Equipment', 'Accessories', 'Fruits & Vegetables', 'Groceries', 'Kitchen & Cooking', 'Clothing & Footwear', 'Books & Learning', 'Travel & Outdoor'
  ];
  final List<IconData> filterIcons = [
    Symbols.apps_rounded, Symbols.fitness_center_rounded, Symbols.fitness_tracker_rounded, Symbols.local_grocery_store_rounded, Symbols.grocery_rounded, Symbols.skillet_rounded, Symbols.checkroom_rounded, Symbols.book_2_rounded, Symbols.camping_rounded
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shopping_cart_rounded),
        title: Text('Shop Module'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {Navigator.pushNamed(context, '/cart');},
            label: Text('Go To Cart'),
            icon: Icon(Icons.shopping_cart_rounded),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      icon: Icon(Symbols.sort_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10,),
                CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    child: IconButton(onPressed: (){}, icon: Icon(Symbols.filter_list_rounded))),
                const SizedBox(width: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(9, ((index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ChoiceChip(
                              shape: StadiumBorder(
                                side: BorderSide(color: filter == index ? Colors.transparent : Theme.of(context).colorScheme.primary),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              showCheckmark: false,
                              label: Text(filterLabels[index]), selected: filter == index,
                            avatar: Icon(filterIcons[index]),
                            onSelected: (select){
                              setState(() {
                                if(select){
                                  filter = index;
                                }
                              });
                            },
                            ),
                          );
                        })
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: Text('Checkout'),
            icon: Icon(Icons.shopping_cart_rounded),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(child: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

        ],
      ))),
    );
  }
}
