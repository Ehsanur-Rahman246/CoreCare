import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class Item{
  final String name;
  final Image photo;
  final String description;
  final FilterType type;
  final int price;
  final int stock;
  final int count;

  Item({required this.name, required this.photo, required this.description, required this.type, required this.price, required this.stock, required this.count});
}

enum SortType {aToZ, zToA, priceLowToHigh, priceHighToLow}
enum FilterType {all, standard, premium}
enum SectionType {all, equip, access, fruits, groceries, cooking, clothing, books, travel}

class _ShopScreenState extends State<ShopScreen> {
  SectionType selectedSection = SectionType.all;
  FilterType selectedFilter = FilterType.all;
  SortType selectedSort = SortType.aToZ;
  FocusNode focusNode = FocusNode();
  final searchController = TextEditingController();
  String query = "";

  final List<String> filterLabels = [
    'All', 'Equipment', 'Accessories', 'Fruits & Vegetables', 'Groceries', 'Kitchen & Cooking', 'Clothing & Footwear', 'Books & Learning', 'Travel & Outdoor'
  ];
  final List<IconData> filterIcons = [
    Symbols.apps_rounded, Symbols.fitness_center_rounded, Symbols.fitness_tracker_rounded, Symbols.local_grocery_store_rounded, Symbols.grocery_rounded, Symbols.skillet_rounded, Symbols.checkroom_rounded, Symbols.book_2_rounded, Symbols.camping_rounded
  ];

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final ch = Theme.of(context).colorScheme;
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
                      focusNode: focusNode,
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search",
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
                  PopupMenuButton(
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          setState(() {
                            selectedSort = SortType.aToZ;
                          });
                          break;
                        case 1:
                          setState(() {
                            selectedSort = SortType.zToA;
                          });
                          break;
                        case 2:
                          setState(() {
                            selectedSort = SortType.priceLowToHigh;
                          });
                          break;
                        case 3:
                          setState(() {
                            selectedSort = SortType.priceHighToLow;
                          });
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Name", style: th.labelLarge,),
                              const SizedBox(width: 8),
                              Icon(Icons.sort_by_alpha_rounded, size: 18,),
                              Icon(Icons.arrow_downward_rounded, size: 18,),
                              if(selectedSort == SortType.aToZ) ...[
                                const SizedBox(width: 15,),
                                Icon(Icons.check, color: ch.primary, size: 18,),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Name", style: th.labelLarge,),
                              const SizedBox(width: 8),
                              Icon(Icons.sort_by_alpha_rounded, size: 18,),
                              Icon(Icons.arrow_upward_rounded, size: 18,),
                              if(selectedSort == SortType.zToA) ...[
                                const SizedBox(width: 15,),
                                Icon(Icons.check, color: ch.primary, size: 18,),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Price", style: th.labelLarge,),
                              const SizedBox(width: 8),
                              Icon(Icons.attach_money_rounded, size: 18,),
                              Icon(Icons.arrow_downward_rounded, size: 18,),
                              if(selectedSort == SortType.priceLowToHigh) ...[
                                const SizedBox(width: 15,),
                                Icon(Icons.check, color: ch.primary, size: 18,),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Price", style: th.labelLarge,),
                              const SizedBox(width: 8),
                              Icon(Icons.attach_money_rounded, size: 18,),
                              Icon(Icons.arrow_upward_rounded, size: 18,),
                              if(selectedSort == SortType.priceHighToLow) ...[
                                const SizedBox(width: 15,),
                                Icon(Icons.check, color: ch.primary, size: 18,),
                              ],
                            ],
                          ),
                        ),
                      ];
                    },
                    icon: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      child: Icon(Symbols.sort_rounded),
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
                PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        setState(() {
                          selectedFilter = FilterType.all;
                        });
                        break;
                      case 1:
                        setState(() {
                          selectedFilter = FilterType.standard;
                        });
                        break;
                      case 2:
                        setState(() {
                          selectedFilter = FilterType.premium;
                        });
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.all_inbox_rounded, size: 18,),
                            const SizedBox(width: 8),
                            Text("All", style: th.labelLarge,),
                            if(selectedFilter == FilterType.all) ...[
                              const SizedBox(width: 15,),
                              Icon(Icons.check, color: ch.primary, size: 18,),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, size: 18,),
                            const SizedBox(width: 8),
                            Text("Standard", style: th.labelLarge,),
                            if(selectedFilter == FilterType.standard) ...[
                              const SizedBox(width: 15,),
                              Icon(Icons.check, color: ch.primary, size: 18,),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 18,),
                            const SizedBox(width: 8),
                            Text("Premium", style: th.labelLarge,),
                            if(selectedFilter == FilterType.premium) ...[
                              const SizedBox(width: 15,),
                              Icon(Icons.check, color: ch.primary, size: 18,),
                            ],
                          ],
                        ),
                      ),
                    ];
                  },
                  icon: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    child: Icon(Symbols.filter_list_rounded),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(SectionType.values.length, ((index) {
                          final section = SectionType.values[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ChoiceChip(
                              shape: StadiumBorder(
                                side: BorderSide(color:  selectedSection == section ? Colors.transparent : Theme.of(context).colorScheme.primary),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              showCheckmark: false,
                              label: Text(filterLabels[index]), selected: selectedSection == section,
                            avatar: Icon(filterIcons[index]),
                            onSelected: (selected){
                              setState(() {
                                if(selected){
                                  selectedSection = section;
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
            icon: Icon(Icons.shopping_cart_checkout_rounded),
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
