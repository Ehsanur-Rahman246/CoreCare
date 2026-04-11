import 'dart:math';
import 'package:core_care/main.dart';
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
  int stock;
  int count;

  Item({required this.name, required this.photo, required this.description, required this.type, required this.price, required this.stock, required this.count});
}

enum SortType {aToZ, zToA, priceLowToHigh, priceHighToLow}
enum FilterType {all, standard, premium}
enum SectionType {all, equip, access, fruits, groceries, cooking, clothing, books, travel}

class CartItem{
  final Item item;
  int quantity;

  CartItem({required this.item, required this.quantity});
}

final List<CartItem> cartedItems = [];

class _ShopScreenState extends State<ShopScreen> {
  SectionType selectedSection = SectionType.all;
  FilterType selectedFilter = FilterType.all;
  SortType selectedSort = SortType.aToZ;
  bool showSearchPanel = false;
  final searchController = TextEditingController();
  String query = "";
  List<Item> displayedItems = [];
  final int recentMaxSize = 6;
  List<Item> recentList = [];
  List<Item> suggestionList = [];


  void refreshList(){
    setState(() {
      displayedItems = getSelectedItems(data: shopItems, section: selectedSection, filter: selectedFilter, sort: selectedSort, searchQuery: query);
    });
  }

  static final List<String> products = [
    // Fitness Equipment
    "Lightweight cast iron dumbbells, perfect for toning and beginner strength training. Rubber-coated for grip safety.",
    "Set of 5 color-coded latex bands with varying resistance levels. Great for stretching, rehab, and full-body workouts.",
    "6mm thick non-slip PVC mat with carrying strap. Ideal for yoga, pilates, and floor exercises.",
    "High-density EVA foam roller for muscle recovery and myofascial release. Compact 30cm size.",
    "Adjustable PVC skipping rope with foam handles. Suitable for cardio warm-ups and HIIT training.",
    "25cm inflatable mini ball for core stability, balance training, and seated workouts.",
    "Vinyl-coated cast iron kettlebell for swings, squats, and functional training. Flat base for stability.",
    "Adjustable resistance hand gripper (10–40kg). Builds forearm and finger strength.",
    "Space-saving dial-select dumbbells replacing 6 pairs. Quick weight change in seconds. Premium steel build.",
    "6mm natural tree rubber mat with alignment lines. Non-toxic, sweat-resistant, and biodegradable.",
    "Competition-grade cast iron kettlebell with powder-coat finish. Uniform size across all weights.",
    "Percussive therapy device with 6 heads and 3 speed settings. Deep-tissue relief for post-workout recovery.",
    "45cm textured high-density roller with grid surface for targeted trigger-point therapy.",
    "Digital LCD counter rope with auto-tangle free cable. Tracks reps, calories, and workout time.",
    "Anti-burst 65cm exercise ball for core, balance, and physiotherapy. Includes pump.",

    // Accessories
    "BPA-free plastic sports bottle with flip-top lid and measurement markings.",
    "Microfiber gym towel (40×80cm). Fast-drying, ultra-absorbent, and machine washable.",
    "Pair of cotton sweatbands to keep hands dry during intense workouts. One size fits most.",
    "20L polyester drawstring bag with ventilated shoe pocket and water-resistant base.",
    "Non-slip grip socks with toe separation for improved balance during yoga and pilates.",
    "Neoprene compression sleeve for knee joint support during squats and running. Size: S–XL.",
    "Elastic elbow brace for tendonitis relief and stability during lifting. Ambidextrous.",
    "600ml hydration tracker with LED reminder every hour and temperature display (stainless steel).",
    "40L waterproof duffel with separate wet compartment, shoe slot, and padded laptop section.",
    "3D contoured memory foam sleep mask with adjustable strap. Blocks 100% light for deep sleep.",
    "Buckwheat-filled zafu cushion with removable cover. Supports correct posture during meditation.",
    "Lotus-spike acupressure mat with pillow set. Stimulates circulation and relieves back tension.",
    "Reusable gel pack for both heat therapy and ice therapy. Flexible even when frozen.",
    "Waterproof activity band tracking steps, heart rate, sleep, and calories. 7-day battery.",
    "Full-featured health smartwatch with GPS, SpO2, stress monitor, and 14-day battery life.",

    // Groceries & Nutrition
    "Fresh red apples (per kg). Rich in fiber and antioxidants. Sourced from local farms.",
    "Ripe yellow bananas (per dozen). High in potassium — ideal post-workout fruit.",
    "Fresh carrots (per 500g pack). High in beta-carotene, great raw or cooked.",
    "Vine-ripened tomatoes (per kg). Versatile, rich in lycopene and Vitamin C.",
    "Fresh spinach leaves (250g bag). Packed with iron, folate, and Vitamin K.",
    "300g blend of organic blueberries, strawberries, and raspberries. Antioxidant powerhouse.",
    "Certified organic kale (200g bag). One of the most nutrient-dense leafy greens available.",
    "Ripe Hass avocado (each). Loaded with heart-healthy monounsaturated fats and potassium.",
    "200g assorted exotic mushrooms (shiitake, oyster, enoki). Rich in umami and immune-boosting beta-glucans.",
    "500g mixed heirloom tomatoes in unique colors and flavors. Superior taste and antioxidant variety.",
    "Premium long-grain white rice (1kg). Fluffy texture, ideal for everyday meals.",
    "1kg old-fashioned rolled oats. Cholesterol-lowering beta-glucan, great for overnight oats.",
    "500g red or green lentils. High in plant protein, fiber, and iron. Cooks in 20 minutes.",
    "500g dried chickpeas. Versatile legume rich in protein and complex carbohydrates.",
    "250g raw almonds. Excellent source of Vitamin E, magnesium, and healthy fats.",
    "Fresh boneless chicken breast (500g). Lean protein, low fat — the fitness staple.",
    "Tray of 12 farm-fresh eggs. Complete protein with all essential amino acids. Versatile cooking.",
    "Fresh salmon fillet (200g). Packed with omega-3 DHA/EPA and high-quality protein.",
    "Box of 25 green tea bags. Rich in EGCG catechins and gentle caffeine for mental focus.",
    "Bottle of 60 tablets covering 20+ essential vitamins and minerals. Once-daily formula.",
    "500g white quinoa. Complete protein with all 9 essential amino acids. Gluten-free superfood.",
    "300g certified organic chia seeds. Loaded with omega-3, fiber, and calcium.",
    "200g grass-fed beef mince or steak cut. Superior omega-3 profile and CLA content vs grain-fed.",
    "Pack of 4 organic whole-food bars (dates, nuts, cacao). 250 kcal, no refined sugar.",
    "300g hydrolyzed bovine collagen peptides. Supports skin elasticity, joint health, and hair growth.",

    // Kitchen Appliances
    "600W personal blender with 2 travel cups (400ml). Ideal for smoothies and protein shakes.",
    "Centrifugal juicer with wide 65mm feed chute. Extracts juice from fruits and vegetables in seconds.",
    "24cm granite-coated non-stick frying pan. PFOA-free, dishwasher-safe, induction compatible.",
    "Set of 10 BPA-free airtight containers (various sizes). Microwave, freezer, and dishwasher safe.",
    "5.5L digital air fryer with 8 presets. Fry, bake, grill with 80% less oil. Easy-clean basket.",
    "800W food processor with 2.5L bowl, S-blade, slicing/shredding discs. Chops, purees, and kneads.",
    "5-piece German stainless steel knife block set. Full-tang blades, triple-riveted ergonomic handles.",
    "Set of 2 non-stick silicone oven mats (40×30cm). Replace parchment paper indefinitely.",

    // Apparel & Shoes
    "100% cotton crew-neck workout tee. Breathable, preshrunk, available in 6 colors. Sizes S–XXL.",
    "Elastic-waist polyester shorts with inner liner and side pockets. 7-inch inseam.",
    "High-waist nylon-spandex leggings with hidden waistband pocket. 4-way stretch.",
    "Mesh upper running shoes with EVA midsole cushioning. Lightweight at 260g. Sizes 38–45.",
    "Cross-training shoes with flat, wide toe box and lateral stability. Multi-surface rubber sole.",
    "French terry premium hoodie with brushed interior. Athleisure design with thumb holes and zip pocket.",
    "Podiatrist-recommended sneakers with deep heel cup, arch support, and wide toe box.",
    "190g ultra-light speed shoes with knit upper and full-length cushioning plate.",

    // Books & Guides
    "128-page illustrated guide covering fundamental workout principles, form, and 12-week beginner plan.",
    "200 quick healthy recipes under 30 minutes. Nutritional info per serving included.",
    "A2 laminated full-body workout poster showing 40 exercises with correct form cues.",
    "Coffee-table format with 300 full-color photos covering flow sequences, anatomy, and adjustments.",
    "Sports dietitian-authored guide on fueling for competition, recovery nutrition, and supplementation.",
    "Smart journal with QR-code workout links, body scan pages, and 12-month progress spreads.",

    // Travel & Portable Fitness
    "4mm foldable travel yoga mat with alignment lines. Folds to 30×20cm. Lightweight at 500g.",
    "350ml collapsible BPA-free silicone bottle. Folds flat when empty. Carabiner clip included.",
    "Single heavy-duty fabric resistance band (medium resistance) in zippered carry pouch.",
    "400g curated organic snack box: goji berries, dark chocolate almonds, cashews, and energy bites.",
    "5-piece outdoor workout kit: resistance bands, jump rope, suspension anchor, gloves, and bag."
  ];

  static final Map<SectionType, List<Item>> shopItems = {
    SectionType.equip : [
      Item(name: '2kg Dumbbells', photo: Image.asset('assets/items/1n1.png'), description: products[0], type: FilterType.standard, price: 650, stock: 20, count: 4),
      Item(name: 'Resistance Bands Set', photo: Image.asset('assets/items/1n2.png'), description: products[1], type: FilterType.standard, price: 480, stock: 25, count: 5),
      Item(name: 'Basic Yoga Mat', photo: Image.asset('assets/items/1n3.png'), description: products[2], type: FilterType.standard, price: 550, stock: 15, count: 3),
      Item(name: 'Foam Roller 30cm', photo: Image.asset('assets/items/1n4.png'), description: products[3], type: FilterType.standard, price: 420, stock: 15, count: 3),
      Item(name: 'Jump Rope', photo: Image.asset('assets/items/1n5.png'), description: products[4], type: FilterType.standard, price: 250, stock: 25, count: 5),
      Item(name: 'Mini Stability Ball', photo: Image.asset('assets/items/1n6.png'), description: products[5], type: FilterType.standard, price: 380, stock: 15, count: 3),
      Item(name: 'Kettlebell 4kg', photo: Image.asset('assets/items/1n7.png'), description: products[6], type: FilterType.standard, price: 850, stock: 15, count: 3),
      Item(name: 'Hand Grip Strengthener', photo: Image.asset('assets/items/1n8.png'), description: products[7], type: FilterType.standard, price: 180, stock: 25, count: 5),
      Item(name: "Adjustable Dumbbells 2-12 kg", photo: Image.asset('assets/items/1p1.png'), description: products[8], type: FilterType.premium, price: 8500, stock: 6, count: 2),
      Item(name: 'Premium Yoga Mat (Eco Friendly)', photo: Image.asset('assets/items/1p2.png'), description: products[9], type: FilterType.premium, price: 2200, stock: 6, count: 2),
      Item(name: 'Heavy-Duty Kettlebell 8kg', photo: Image.asset('assets/items/1p3.png'), description: products[10], type: FilterType.premium, price: 1800, stock: 9, count: 3),
      Item(name: 'Vibrating Massage Gun', photo: Image.asset('assets/items/1p4.png'), description: products[11], type: FilterType.premium, price: 4500, stock: 6, count: 2),
      Item(name: 'Professional Foam Roller', photo: Image.asset('assets/items/1p5.png'), description: products[12], type: FilterType.premium, price: 1200, stock: 6, count: 2),
      Item(name: 'Smart Jump Rope', photo: Image.asset('assets/items/1p6.png'), description: products[13], type: FilterType.premium, price: 1600, stock: 6, count: 2),
      Item(name: 'Large Stability Ball', photo: Image.asset('assets/items/1p7.png'), description: products[14], type: FilterType.premium, price: 1400, stock: 6, count: 2),
    ],
    SectionType.access : [
      Item(name: 'Water Bottle 500ml', photo: Image.asset('assets/items/2n1.png'), description: products[15], type: FilterType.standard, price: 150, stock: 25, count: 5),
      Item(name: 'Sweat Towel', photo: Image.asset('assets/items/2n2.png'), description: products[16], type: FilterType.standard, price: 180, stock: 25, count: 5),
      Item(name: 'Wristbands', photo: Image.asset('assets/items/2n3.png'), description: products[17], type: FilterType.standard, price: 120, stock: 30, count: 6),
      Item(name: 'Gym bag Small', photo: Image.asset('assets/items/2n4.png'), description: products[18], type: FilterType.standard, price: 650, stock: 15, count: 3),
      Item(name: 'Yoga Socks', photo: Image.asset('assets/items/2n5.png'), description: products[19], type: FilterType.standard, price: 220, stock: 20, count: 4),
      Item(name: 'Knee Support', photo: Image.asset('assets/items/2n6.png'), description: products[20], type: FilterType.standard, price: 350, stock: 20, count: 4),
      Item(name: 'Elbow Support', photo: Image.asset('assets/items/2n7.png'), description: products[21], type: FilterType.standard, price: 300, stock: 20, count: 4),
      Item(name: 'Smart Water Bottle', photo: Image.asset('assets/items/2p1.png'), description: products[22], type: FilterType.premium, price: 2800, stock: 6, count: 2),
      Item(name: 'Large Gym Bag', photo: Image.asset('assets/items/2p2.png'), description: products[23], type: FilterType.premium, price: 3200, stock: 6, count: 2),
      Item(name: 'Sleep Mask Memory Foam', photo: Image.asset('assets/items/2p3.png'), description: products[24], type: FilterType.premium, price: 1100, stock: 9, count: 3),
      Item(name: 'Meditation Cushion', photo: Image.asset('assets/items/2p4.png'), description: products[25], type: FilterType.premium, price: 1800, stock: 6, count: 2),
      Item(name: 'Acupressure Mat', photo: Image.asset('assets/items/2p5.png'), description: products[26], type: FilterType.premium, price: 2500, stock: 6, count: 2),
      Item(name: 'Hot/Cold Pack Gel', photo: Image.asset('assets/items/2p6.png'), description: products[27], type: FilterType.premium, price: 900, stock: 12, count: 4),
      Item(name: 'Fitness Tracker', photo: Image.asset('assets/items/2p7.png'), description: products[28], type: FilterType.premium, price: 3500, stock: 6, count: 2),
      Item(name: 'Smartwatch', photo: Image.asset('assets/items/2p8.png'), description: products[29], type: FilterType.premium, price: 12000, stock: 3, count: 1),
    ],
    SectionType.fruits : [
      Item(name: 'Apples', photo: Image.asset('assets/items/3n1.png'), description: products[30], type: FilterType.standard, price: 180, stock: 25, count: 5),
      Item(name: 'Bananas', photo: Image.asset('assets/items/3n2.png'), description: products[31], type: FilterType.standard, price: 80, stock: 25, count: 5),
      Item(name: 'Carrots', photo: Image.asset('assets/items/3n3.png'), description: products[32], type: FilterType.standard, price: 60, stock: 30, count: 6),
      Item(name: 'Tomatoes', photo: Image.asset('assets/items/3n4.png'), description: products[33], type: FilterType.standard, price: 80, stock: 25, count: 5),
      Item(name: 'Spinach', photo: Image.asset('assets/items/3n5.png'), description: products[34], type: FilterType.standard, price: 70, stock: 25, count: 5),
      Item(name: 'Organic Berries Mix', photo: Image.asset('assets/items/3p1.png'), description: products[35], type: FilterType.premium, price: 650, stock: 15, count: 3),
      Item(name: 'Organic Kale', photo: Image.asset('assets/items/3p2.png'), description: products[36], type: FilterType.premium, price: 320, stock: 15, count: 3),
      Item(name: 'Avocado', photo: Image.asset('assets/items/3p3.png'), description: products[37], type: FilterType.premium, price: 420, stock: 30, count: 6),
      Item(name: 'Exotic Mushrooms', photo: Image.asset('assets/items/3p4.png'), description: products[38], type: FilterType.premium, price: 380, stock: 15, count: 3),
      Item(name: 'Heirloom Tomatoes', photo: Image.asset('assets/items/3p5.png'), description: products[39], type: FilterType.premium, price: 350, stock: 15, count: 3),
    ],
    SectionType.groceries : [
      Item(name: 'White Rice', photo: Image.asset('assets/items/4n1.png'), description: products[40], type: FilterType.standard, price: 90, stock: 50, count: 10),
      Item(name: 'Rolled Oats', photo: Image.asset('assets/items/4n2.png'), description: products[41], type: FilterType.standard, price: 220, stock: 30, count: 6),
      Item(name: 'Lentils', photo: Image.asset('assets/items/4n3.png'), description: products[42], type: FilterType.standard, price: 110, stock: 40, count: 8),
      Item(name: 'Chickpeas', photo: Image.asset('assets/items/4n4.png'), description: products[43], type: FilterType.standard, price: 130, stock: 40, count: 8),
      Item(name: 'Almonds', photo: Image.asset('assets/items/4n5.png'), description: products[44], type: FilterType.standard, price: 480, stock: 25, count: 5),
      Item(name: 'Chicken Breast', photo: Image.asset('assets/items/4n6.png'), description: products[45], type: FilterType.standard, price: 320, stock: 25, count: 5),
      Item(name: 'Eggs', photo: Image.asset('assets/items/4n7.png'), description: products[46], type: FilterType.standard, price: 160, stock: 25, count: 5),
      Item(name: 'Salmon (fresh)', photo: Image.asset('assets/items/4n8.png'), description: products[47], type: FilterType.standard, price: 680, stock: 15, count: 3),
      Item(name: 'Green Tea', photo: Image.asset('assets/items/4n9.png'), description: products[48], type: FilterType.standard, price: 160, stock: 25, count: 5),
      Item(name: 'Multivitamins', photo: Image.asset('assets/items/4n10.png'), description: products[49], type: FilterType.standard, price: 480, stock: 15, count: 3),
      Item(name: 'Quinoa', photo: Image.asset('assets/items/4p1.png'), description: products[50], type: FilterType.premium, price: 650, stock: 25, count: 5),
      Item(name: 'Organic Chia Seeds', photo: Image.asset('assets/items/4p2.png'), description: products[51], type: FilterType.premium, price: 580, stock: 20, count: 4),
      Item(name: 'Grass-Fed Beef', photo: Image.asset('assets/items/4p3.png'), description: products[52], type: FilterType.premium, price: 1200, stock: 15, count: 3),
      Item(name: 'Organic Energy Bars', photo: Image.asset('assets/items/4p4.png'), description: products[53], type: FilterType.premium, price: 680, stock: 20, count: 4),
      Item(name: 'Collagen Powder', photo: Image.asset('assets/items/4p5.png'), description: products[54], type: FilterType.premium, price: 2800, stock: 10, count: 2),
    ],
    SectionType.cooking : [
      Item(name: 'Blender', photo: Image.asset('assets/items/5n1.png'), description: products[55], type: FilterType.standard, price: 1800, stock: 10, count: 2),
      Item(name: 'Juicer', photo: Image.asset('assets/items/5n2.png'), description: products[56], type: FilterType.standard, price: 2200, stock: 10, count: 2),
      Item(name: 'Non-Stick Pan', photo: Image.asset('assets/items/5n3.png'), description: products[57], type: FilterType.standard, price: 950, stock: 15, count: 3),
      Item(name: 'Meal Prep Containers', photo: Image.asset('assets/items/5n4.png'), description: products[58], type: FilterType.standard, price: 750, stock: 15, count: 3),
      Item(name: 'Air Fryer', photo: Image.asset('assets/items/5p1.png'), description: products[59], type: FilterType.premium, price: 6500, stock: 5, count: 1),
      Item(name: 'Food Processor', photo: Image.asset('assets/items/5p2.png'), description: products[60], type: FilterType.premium, price: 5800, stock: 5, count: 1),
      Item(name: 'Premium Knife Set', photo: Image.asset('assets/items/5p3.png'), description: products[61], type: FilterType.premium, price: 5200, stock: 5, count: 1),
      Item(name: 'Silicone Baking Mats', photo: Image.asset('assets/items/5p4.png'), description: products[62], type: FilterType.premium, price: 1200, stock: 15, count: 3),
    ],
    SectionType.clothing : [
      Item(name: 'Cotton T-Shirt', photo: Image.asset('assets/items/6n1.png'), description: products[63], type: FilterType.standard, price: 350, stock: 25, count: 5),
      Item(name: 'premium', photo: Image.asset('assets/items/6n2.png'), description: products[64], type: FilterType.standard, price: 420, stock: 20, count: 4),
      Item(name: 'Basic Leggings', photo: Image.asset('assets/items/6n3.png'), description: products[65], type: FilterType.standard, price: 680, stock: 15, count: 3),
      Item(name: 'Running Shoes', photo: Image.asset('assets/items/6n4.png'), description: products[66], type: FilterType.standard, price: 2500, stock: 10, count: 2),
      Item(name: 'Training Shoes', photo: Image.asset('assets/items/6n5.png'), description: products[67], type: FilterType.standard, price: 2200, stock: 10, count: 2),
      Item(name: 'Designer Hoodie', photo: Image.asset('assets/items/6p1.png'), description: products[68], type: FilterType.premium, price: 3800, stock: 10, count: 2),
      Item(name: 'Orthopedic Sneakers', photo: Image.asset('assets/items/6p2.png'), description: products[69], type: FilterType.premium, price: 7200, stock: 10, count: 2),
      Item(name: 'Lightweight Performance Shoes', photo: Image.asset('assets/items/6p3.png'), description: products[70], type: FilterType.premium, price: 9800, stock: 5, count: 1),
    ],
    SectionType.books : [
      Item(name: 'Beginner Fitness Guide', photo: Image.asset('assets/items/7n1.png'), description: products[71], type: FilterType.standard, price: 450, stock: 15, count: 3),
      Item(name: 'Healthy Recipes Book', photo: Image.asset('assets/items/7n2.png'), description: products[72], type: FilterType.standard, price: 520, stock: 15, count: 3),
      Item(name: 'Exercise Poster', photo: Image.asset('assets/items/7n3.png'), description: products[73], type: FilterType.standard, price: 180, stock: 25, count: 5),
      Item(name: 'Premium Illustrated Yoga Guide', photo: Image.asset('assets/items/7p1.png'), description: products[74], type: FilterType.premium, price: 2200, stock: 10, count: 2),
      Item(name: 'High-Performance Athlete Nutrition', photo: Image.asset('assets/items/7p2.png'), description: products[75], type: FilterType.premium, price: 1500, stock: 10, count: 2),
      Item(name: 'Digital Fitness Tracker Journal', photo: Image.asset('assets/items/7p3.png'), description: products[76], type: FilterType.premium, price: 1400, stock: 10, count: 2),
    ],
    SectionType.travel : [
      Item(name: 'Foldable Yoga Mat', photo: Image.asset('assets/items/8n1.png'), description: products[77], type: FilterType.standard, price: 680, stock: 15, count: 3),
      Item(name: 'Travel Water Bottle', photo: Image.asset('assets/items/8n2.png'), description: products[78], type: FilterType.standard, price: 350, stock: 20, count: 4),
      Item(name: 'Portable Resistance Band', photo: Image.asset('assets/items/8n3.png'), description: products[79], type: FilterType.standard, price: 180, stock: 25, count: 5),
      Item(name: 'Premium Travel Snack Pack', photo: Image.asset('assets/items/8p1.png'), description: products[80], type: FilterType.premium, price: 980, stock: 15, count: 3),
      Item(name: 'Outdoor Fitness Kit', photo: Image.asset('assets/items/8p2.png'), description: products[81], type: FilterType.premium, price: 4500, stock: 15, count: 3),
    ],
  };

  final List<String> filterLabels = [
    'All', 'Equipment', 'Accessories', 'Fruits & Vegetables', 'Groceries', 'Kitchen & Cooking', 'Clothing & Footwear', 'Books & Learning', 'Travel & Outdoor'
  ];
  final List<IconData> filterIcons = [
    Symbols.apps_rounded, Symbols.fitness_center_rounded, Symbols.fitness_tracker_rounded, Symbols.local_grocery_store_rounded, Symbols.grocery_rounded, Symbols.skillet_rounded, Symbols.checkroom_rounded, Symbols.book_2_rounded, Symbols.camping_rounded
  ];



  List<Item> getSuggestionForYou({required Map<SectionType , List<Item>> data}){
    List<Item> init = data.values.expand((list) => list).toList();
    init.shuffle(Random());
    List<Item> result = init.take(6).toList();

    return result;
  }

  List<Item> getSelectedItems({required Map<SectionType , List<Item>> data, required SectionType section, required FilterType filter, required SortType sort, String searchQuery = "",}){
    List<Item> result = section == SectionType.all ? data.values.expand((list) => list).toList() : data[section] ?? [];
    if(filter != FilterType.all){
      result = result.where((item) => item.type == filter).toList();
    }
    if(searchQuery.isNotEmpty){
      final q = searchQuery.toLowerCase();
      final List<Item> nameMatches = [];
      final List<Item> descriptionMatches = [];
      for(var item in result){
        if(item.name.toLowerCase().contains(q)){
          nameMatches.add(item);
        }else if(item.description.toLowerCase().contains(q)){
          descriptionMatches.add(item);
        }
      }
      result = [...nameMatches, ...descriptionMatches];
    }

    switch(sort){
      case SortType.aToZ:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.zToA:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortType.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return result;
  }

  void addRecentItem(Item item){
    if(recentList.length >= recentMaxSize){
      recentList.removeLast();
    }
    recentList.insert(0, item);
  }

  @override
  void initState() {
    super.initState();
    suggestionList = getSuggestionForYou(data: shopItems);

    searchController.addListener((){
      setState(() {});
    });
    displayedItems = getSelectedItems(data: shopItems, section: selectedSection, filter: selectedFilter, sort: selectedSort, searchQuery: query);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            onPressed: () {Navigator.pushNamed(context, '/cart').then((_) {if(mounted) setState(() {});});},
            label: Text('Go To Cart'),
            icon: Icon(Icons.shopping_cart_rounded),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GestureDetector(
        onTap: (){
          if(showSearchPanel){
            setState(() => showSearchPanel = false);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (val){
                          setState(() {
                            query = val;
                            showSearchPanel = val.isEmpty;
                            refreshList();
                          });
                        },
                        onTap: (){setState(() => showSearchPanel = true);},
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.search),
                          labelText: "Search",
                          suffixIcon: (showSearchPanel && searchController.text.isNotEmpty) ? IconButton(onPressed: (){searchController.clear(); query = ""; showSearchPanel = true; refreshList();}, icon: Icon(Icons.clear),) : SizedBox.shrink(),
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
                      tooltip: 'Sort By',
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            setState(() {
                              selectedSort = SortType.aToZ;
                              refreshList();
                            });
                            break;
                          case 1:
                            setState(() {
                              selectedSort = SortType.zToA;
                              refreshList();
                            });
                            break;
                          case 2:
                            setState(() {
                              selectedSort = SortType.priceLowToHigh;
                              refreshList();
                            });
                            break;
                          case 3:
                            setState(() {
                              selectedSort = SortType.priceHighToLow;
                              refreshList();
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
              const SizedBox(height: 10),
              if(showSearchPanel && searchController.text.isEmpty) ...[
                if(recentList.isNotEmpty) ...[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Recent', style: th.labelLarge,)),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(recentList.length, ((index) {
                      final recent = recentList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: (){
                            setState(() => showSearchPanel = false);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(item: recent)));
                            recentList.remove(recent);
                            addRecentItem(recent);
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: recent.photo.image,
                          ),
                        ),
                      );
                    })
                    ),
                  ),
                ],
                const SizedBox(height: 25,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('For You', style: th.titleSmall,)),
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: suggestionList.length,
                      itemBuilder: (context, index){
                      final suggest = suggestionList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: (){
                            setState(() => showSearchPanel = false);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(item: suggest)));
                            if(recentList.contains(suggest)){
                              recentList.remove(suggest);
                              addRecentItem(suggest);
                            }else{
                              addRecentItem(suggest);
                            }
                          },
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: suggest.photo.image,
                          ),
                          title: Text(suggest.name),
                          titleTextStyle: th.bodyLarge,
                          trailing: Icon(Icons.chevron_right_rounded),
                        ),
                      );
                  }),
                ),
                const SizedBox(height: 70,),
              ]
              else ...[
                if(displayedItems.isEmpty)
                  Center(child: Text('No Matches Found', style: th.titleSmall,),)
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10,),
                      PopupMenuButton(
                        tooltip: 'Filter By',
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              setState(() {
                                selectedFilter = FilterType.all;
                                refreshList();
                              });
                              break;
                            case 1:
                              setState(() {
                                selectedFilter = FilterType.standard;
                                refreshList();
                              });
                              break;
                            case 2:
                              setState(() {
                                selectedFilter = FilterType.premium;
                                refreshList();
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
                                          refreshList();
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListView.builder(
                        itemCount: displayedItems.length,
                        itemBuilder: (context, index){
                          final item = displayedItems[index];
                          return Card(
                            color: item.type == FilterType.premium ? CustomColors.gold(context) : ch.surface,
                            elevation: 0,
                            child: ListTile(
                              leading: SizedBox(
                                height: 60,
                                width: 60,
                                child: item.photo,
                              ),
                              title: Text(item.name),
                              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                              subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Text('৳${item.price}'), const SizedBox(width: 25,), item.stock != 0 ? Text('In stock: ${item.stock}') : Text('Out of stock')]),
                              subtitleTextStyle: Theme.of(context).textTheme.labelLarge,
                              trailing: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => ItemScreen(item: item,))).then((_) {if(mounted) setState(() {});}); addRecentItem(item);}, icon: Icon(Icons.shopping_bag_rounded)),
                            ),
                          );
                        }
                    ),
                  ),
                ),
                const SizedBox(height: 70,),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ItemScreen extends StatefulWidget {
  final Item item;
  const ItemScreen({super.key, required this.item});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int getItemMax = 1;

  void showStockEmpty(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item out of stock')));
  }

  void cartDialog(){
    if(widget.item.stock == 0) return;

    final maxItems = widget.item.count < widget.item.stock ? widget.item.count : widget.item.stock;
    if(maxItems <= 0) return;

    getItemMax = 1;
    showDialog(context: context, builder: (_){
      return StatefulBuilder(builder: (context, setDialog){
        return AlertDialog(
          title: Text('Quantity of your order'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: getItemMax <= 1 ? null : () => setDialog(() => getItemMax--), icon: Icon(Icons.remove_circle_outline_rounded, size: 34,),
                disabledColor: CustomColors.greyLight(context),
              ),
              RichText(text: TextSpan(
                children: [
                  TextSpan(text: '$getItemMax ', style: Theme.of(context).textTheme.titleMedium,),
                  TextSpan(text: getItemMax == 1 ? 'unit' : 'units', style: Theme.of(context).textTheme.titleMedium,),
                ]
              )),
              IconButton(
                onPressed: getItemMax >= maxItems ? null : () => setDialog(() => getItemMax++), icon: Icon(Icons.add_circle_outline_rounded, size: 34,),
                disabledColor: CustomColors.greyLight(context),
              ),
            ],
          ),
          actions: [
            OutlinedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
            FilledButton(onPressed: (){
              setState(() {
                widget.item.stock -= getItemMax;
                cartedItems.add(CartItem(item: widget.item, quantity: getItemMax));
              });
              Navigator.pop(context);
            }, child: Text('Add')),
          ],
        );
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: widget.item.stock != 0 ? cartDialog : showStockEmpty, label: Row(mainAxisSize: MainAxisSize.min, children: [widget.item.stock != 0 ? Icon(Icons.add_shopping_cart_rounded) : Icon(Icons.remove_shopping_cart_rounded), widget.item.stock != 0 ? Text('Add to cart') : Text('Out of Stock')],)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Image(
                            image: widget.item.photo.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                    ),
                    Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.chevron_left_rounded, size: 40, color: CustomColors.black(context),))
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),child: Text(widget.item.name, style: th.titleSmall,)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: Text(widget.item.description, style: th.labelLarge,)),
              const SizedBox(height: 15,),
              Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),child: Text('Price: ৳${widget.item.price} / unit',)),
              Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),child: Text(widget.item.stock != 0 ? 'In stock: ${widget.item.stock}' : 'Out of stock')),
            ],
          ),
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

  void showPaymentDialog (){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text('Your total Bill is'),
        content: Text('৳${totalBill()}', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
        actions: [
          OutlinedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          FilledButton(onPressed: (){
            setState(() {
              cartedItems.clear();
            });
            Navigator.pop(context);
          }, child: Text('Pay')),
        ],
      );
    });
  }

  void showEmpty(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add to cart First')));
  }

  void removeItem(CartItem cart){
    setState(() {
      cart.item.stock += cart.quantity;
      cartedItems.remove(cart);
    });
  }
  void reduceItem(CartItem cart){
    if(cart.quantity <= 1) return;
    setState(() {
      cart.item.stock += 1;
      cart.quantity -= 1;
    });
  }

  void increaseItem(CartItem cart){
    if(cart.item.stock == 0) return;
    setState(() {
      cart.item.stock -= 1;
      cart.quantity += 1;
    });
  }

  String showItemPrice(CartItem cart){
    return '${cart.quantity * cart.item.price}';
  }

  int totalBill(){
    int bill = 0;
    for(var item in cartedItems){
      bill += item.quantity * item.item.price;
    }
    return bill;
  }

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
            onPressed: cartedItems.isNotEmpty ? () => showPaymentDialog() : showEmpty,
            label: Text('Checkout'),
            icon: Icon(Icons.shopping_cart_checkout_rounded),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(child:
      cartedItems.isEmpty ?
          Center(child: Text('Your cart is empty')) :
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: cartedItems.length,
                    itemBuilder: (context, index){
                      final items = cartedItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(height:60, width: 60, child: items.item.photo),
                            title: Text(items.item.name),
                            subtitle: Row(children: [IconButton(onPressed: items.quantity <= 1 ? null : () => reduceItem(items), icon: Icon(Icons.remove_circle_outline_rounded)), Text('${items.quantity}'), IconButton(onPressed: (items.quantity >= items.item.count || items.item.stock == 0) ? null : () => increaseItem(items) , icon: Icon(Icons.add_circle_outline_rounded)), const SizedBox(width: 15,), Text('Total: ৳${showItemPrice(items)}')]),
                            trailing: IconButton(onPressed: () => removeItem(items), icon: Icon(Icons.remove_shopping_cart_rounded)),
                          ),
                        ),
                      );
                    }),
              ),
              const  SizedBox(height: 70,),
            ],
          ),
      ),
    );
  }
}
