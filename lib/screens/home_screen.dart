import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory = 'All'; // instead of null

  SortOption? selectedSort;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final products = productProvider.filteredAndSortedProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          "F A S H I O N   S T O R E",
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // 🔍 Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        productProvider.searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // 🧮 Filter & Sort Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Filter
                        DropdownButton<String>(
                          value: selectedCategory,
                          hint: const Text("Category"),
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text("All")),
                            DropdownMenuItem(
                              value: "T-shirts",
                              child: Text("T-shirts"),
                            ),
                            DropdownMenuItem(
                              value: "Shoes",
                              child: Text("Shoes"),
                            ),
                            DropdownMenuItem(
                              value: "Bags",
                              child: Text("Bags"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => selectedCategory = value);
                            productProvider.filterByCategory(
                              value,
                            ); // sends 'All' if that's selected
                          },
                        ),

                        // Sort Option
                        DropdownButton<SortOption>(
                          value: selectedSort,
                          hint: const Text("Sort"),
                          items: const [
                            DropdownMenuItem(
                              value: SortOption.priceAsc,
                              child: Text("Price ↑"),
                            ),
                            DropdownMenuItem(
                              value: SortOption.priceDesc,
                              child: Text("Price ↓"),
                            ),
                            DropdownMenuItem(
                              value: SortOption.nameAsc,
                              child: Text("Name A-Z"),
                            ),
                            DropdownMenuItem(
                              value: SortOption.newest,
                              child: Text("Newest"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => selectedSort = value);
                            productProvider.sortProducts(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  // 🧺 Product Grid
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text("No products found."))
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                            itemBuilder: (context, index) {
                              return ProductCard(product: products[index]);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
