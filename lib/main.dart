
import 'package:flutter/material.dart';

void main() {
  runApp(const MyStoreCustomer());
}

class MyStoreCustomer extends StatelessWidget {
  const MyStoreCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyStore',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const CustomerHome(),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
}

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int selectedIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  final List<Product> products = [
    const Product(
      name: 'ساعة ذكية',
      description: 'ساعة ذكية متعددة الوظائف',
      price: 89,
      icon: Icons.watch,
      color: Color(0xFFE0E7FF),
    ),
    const Product(
      name: 'سماعات لاسلكية',
      description: 'سماعات بصوت عالي الجودة',
      price: 49,
      icon: Icons.headphones,
      color: Color(0xFFFFEDD5),
    ),
    const Product(
      name: 'حقيبة ظهر',
      description: 'حقيبة عملية للاستعمال اليومي',
      price: 65,
      icon: Icons.backpack,
      color: Color(0xFFD1FAE5),
    ),
    const Product(
      name: 'هاتف ذكي',
      description: 'هاتف ذكي بتصميم عصري',
      price: 599,
      icon: Icons.phone_android,
      color: Color(0xFFFCE7F3),
    ),
  ];

  final List<Product> cart = [];

  final List<Map<String, String>> myOrders = [];

  List<Product> get filteredProducts {
    final query = searchController.text.toLowerCase();

    return products.where((product) {
      return product.name.toLowerCase().contains(query);
    }).toList();
  }

  double get total {
    return cart.fold(0, (sum, product) => sum + product.price);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'MyStore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() => selectedIndex = 1);
              },
              icon: Badge(
                label: Text('${cart.length}'),
                isLabelVisible: cart.isNotEmpty,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: [
            homePage(),
            cartPage(),
            ordersPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'السلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'طلباتي',
            ),
          ],
        ),
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF1E40AF),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بك في MyStore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'اكتشف منتجاتنا وتسوق بسهولة',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'منتجات المتجر',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            return productCard(product);
          },
        ),

        if (filteredProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: Text('لم يتم العثور على منتجات'),
            ),
          ),
      ],
    );
  }

  Widget productCard(Product product) {
    return InkWell(
      onTap: () => showProductDetails(product),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: product.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  product.icon,
                  size: 65,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(0)} د.ت',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.add_circle,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: product.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    product.icon,
                    size: 85,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(product.description),
                const SizedBox(height: 15),
                Text(
                  '${product.price} د.ت',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => cart.add(product));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('تمت إضافة المنتج إلى السلة'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('أضف إلى السلة'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cartPage() {
    return Column(
      children: [
        Expanded(
          child: cart.isEmpty
              ? const Center(
                  child: Text(
                    'سلة المشتريات فارغة',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final product = cart[index];

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(
                          product.icon,
                          color: Colors.blue,
                        ),
                        title: Text(product.name),
                        subtitle: Text('${product.price} د.ت'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() => cart.removeAt(index));
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (cart.isNotEmpty)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'المجموع:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} د.ت',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkout,
                    child: const Text('إتمام الشراء'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void checkout() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('معلومات التوصيل'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'العنوان',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'طريقة الدفع: نقداً عند الاستلام',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty ||
                      addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى ملء جميع المعلومات'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    myOrders.add({
                      'name': nameController.text.trim(),
                      'phone': phoneController.text.trim(),
                      'address': addressController.text.trim(),
                      'total': total.toStringAsFixed(2),
                    });

                    cart.clear();
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تسجيل طلبك بنجاح'),
                    ),
                  );
                },
                child: const Text('تأكيد الطلب'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget ordersPage() {
    if (myOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 65,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'لا توجد طلبات حتى الآن',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: myOrders.length,
      itemBuilder: (context, index) {
        final order = myOrders[index];

        return Card(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.shopping_bag),
            ),
            title: Text('طلب رقم ${index + 1}'),
            subtitle: Text(
              'المجموع: ${order['total']} د.ت\n'
              'الاسم: ${order['name']}',
            ),
            isThreeLine: true,
            trailing: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }
}