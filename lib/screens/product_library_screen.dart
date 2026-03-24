import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/advance_filter_widget.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../data/product_mock_data.dart';

class ProductLibraryScreen extends StatefulWidget {
  const ProductLibraryScreen({super.key});

  @override
  State<ProductLibraryScreen> createState() => _ProductLibraryScreenState();
}

class _ProductLibraryScreenState extends State<ProductLibraryScreen> {
  final _searchController = TextEditingController();
  bool _isListView = true;
  String _searchQuery = '';
  final Map<String, String?> _productFilters = {};

  // Grid view drill-down state
  ProductSegment? _selectedSegment;
  ProductCategory? _selectedCategory;
  ProductSubcategory? _selectedSubcategory;

  // Expanded product details in list view
  final Set<String> _expandedProducts = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> products = ProductMockData.allProducts;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      products = products
          .where(
            (p) =>
                p.code.toLowerCase().contains(q) ||
                p.name.toLowerCase().contains(q),
          )
          .toList();
    }
    final segment = _productFilters['segment'];
    final category = _productFilters['category'];
    final subCategory = _productFilters['subCategory'];
    final brand = _productFilters['brand'];
    final productType = _productFilters['productType'];
    final status = _productFilters['status'];
    if (segment != null) {
      products = products.where((p) => p.segment == segment).toList();
    }
    if (category != null) {
      products = products.where((p) => p.category == category).toList();
    }
    if (subCategory != null) {
      products = products.where((p) => p.subcategory == subCategory).toList();
    }
    if (brand != null) {
      products = products.where((p) => p.brand == brand).toList();
    }
    if (productType != null) {
      products = products.where((p) => p.productType == productType).toList();
    }
    if (status != null) {
      products = products.where((p) => p.status == status).toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // ── Header ──
          _buildHeader(headerColor),
          // ── Body ──
          Expanded(child: _isListView ? _buildListBody() : _buildGridBody()),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildHeader(Color headerColor) {
    return Container(
      color: headerColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            'Product Library',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  LIST VIEW BODY
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildListBody() {
    final products = _filteredProducts;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildSearchAndFilterBar()),
        if (products.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList.builder(
              itemCount: products.length,
              itemBuilder: (_, i) => _buildProductCard(products[i]),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SEARCH BAR + FILTER + TOGGLE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSearchAndFilterBar() {
    final headerColor = context.watch<AppState>().headerColor;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          // Search + View Toggle
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextInput(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          hintText: 'Search Records',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildViewToggle(),
            ],
          ),
          const SizedBox(height: 12),
          // Advance Filter
          AdvanceFilterWidget(
            fields: [
              AdvanceFilterField(
                key: 'segment',
                label: 'Segment',
                hint: 'Select Segment',
                items: ProductMockData.allSegmentNames,
              ),
              AdvanceFilterField(
                key: 'category',
                label: 'Category',
                hint: 'Select Category',
                items: ProductMockData.allCategoryNames,
              ),
              AdvanceFilterField(
                key: 'subCategory',
                label: 'Sub-Category',
                hint: 'Select Sub-Category',
                items: ProductMockData.allSubcategoryNames,
              ),
              AdvanceFilterField(
                key: 'brand',
                label: 'Brand',
                hint: 'Select Brand',
                items: ProductMockData.allBrands,
              ),
              AdvanceFilterField(
                key: 'uom',
                label: 'Unit of Measure',
                hint: 'Select Unit',
                items: ProductMockData.allUOMs,
              ),
              AdvanceFilterField(
                key: 'productType',
                label: 'Product Type',
                hint: 'Select Product Type',
                items: ProductMockData.allProductTypes,
              ),
              AdvanceFilterField(
                key: 'status',
                label: 'Status',
                hint: 'Select Status',
                items: ProductMockData.allStatuses,
              ),
            ],
            values: _productFilters,
            onChanged: (v) => setState(() => _productFilters.addAll(v)),
            onApply: () {},
            applyButtonColor: headerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    final headerColor = context.watch<AppState>().headerColor;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _isListView = true;
              _selectedSegment = null;
              _selectedCategory = null;
              _selectedSubcategory = null;
            }),
            child: Container(
              width: 40,
              height: 38,
              decoration: BoxDecoration(
                color: _isListView ? headerColor : Colors.white,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.format_list_bulleted,
                size: 20,
                color: _isListView ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isListView = false),
            child: Container(
              width: 40,
              height: 38,
              decoration: BoxDecoration(
                color: !_isListView ? headerColor : Colors.white,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: !_isListView ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  PRODUCT CARD (LIST VIEW)
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildProductCard(Product product) {
    final isExpanded = _expandedProducts.contains(product.code);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header
          InkWell(
            onTap: () => _showProductDetail(product),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code + status badge
                  Row(
                    children: [
                      Text(
                        product.code,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: product.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied ${product.code}'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const Spacer(),
                      _statusBadge(product.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: product.name));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied description'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // UOM details row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image placeholder
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          size: 30,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Left UOM column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _uomRow('Base UOM:', product.baseUOM, true),
                            _uomRow('SOH WHS:', '${product.sohWHS}', false),
                            _uomRow('SOH OO:', '${product.sohOO}', false),
                            _uomRow('SOH OT:', '${product.sohOT}', false),
                          ],
                        ),
                      ),
                      // Right UOM column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _uomRow(
                              'Alternative UOM:',
                              product.alternativeUOM,
                              true,
                            ),
                            _uomRow('SOH WHSO:', '${product.sohWHSO}', false),
                            _uomRow('SOH IT:', '${product.sohIT}', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Product Details expandable
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedProducts.remove(product.code);
                } else {
                  _expandedProducts.add(product.code);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Details',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _buildExpandedDetails(product),
        ],
      ),
    );
  }

  Widget _uomRow(String label, String value, bool isBold) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExpandedDetails(Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('Segment', product.segment),
          _detailRow('Category', product.category),
          _detailRow('Subcategory', product.subcategory),
          _detailRow('Base UOM', product.baseUOM),
          _detailRow('Alternative UOM', product.alternativeUOM),
          _detailRow('BOM Type', product.bomType),
          _detailRow('Stock Type', product.stockType),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  PRODUCT DETAIL BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════════════

  void _showProductDetail(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductDetailSheet(product: product),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  GRID VIEW BODY
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildGridBody() {
    return Column(
      children: [
        _buildSearchAndFilterBar(),
        Expanded(
          child: _selectedSubcategory != null
              ? _buildSubcategoryProductsGrid()
              : _selectedCategory != null
              ? _buildSubcategoriesGrid()
              : _selectedSegment != null
              ? _buildCategoriesGrid()
              : _buildSegmentsGrid(),
        ),
      ],
    );
  }

  // ── Segments Grid ──

  Widget _buildSegmentsGrid() {
    final segments = ProductMockData.segments;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: segments.length,
      itemBuilder: (_, i) => _gridCard(
        icon: segments[i].icon,
        label: segments[i].name,
        status: segments[i].status,
        onTap: () => setState(() => _selectedSegment = segments[i]),
      ),
    );
  }

  // ── Categories Grid ──

  Widget _buildCategoriesGrid() {
    final categories = _selectedSegment!.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back navigation
        GestureDetector(
          onTap: () => setState(() => _selectedSegment = null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Back to Segment',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            _selectedSegment!.name,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (_, i) => _gridCard(
              icon: categories[i].icon,
              label: categories[i].name,
              onTap: () => setState(() => _selectedCategory = categories[i]),
            ),
          ),
        ),
      ],
    );
  }

  // ── Subcategories Grid ──

  Widget _buildSubcategoriesGrid() {
    final subcategories = _selectedCategory!.subcategories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedCategory = null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Back to Categories',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            _selectedCategory!.name,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: subcategories.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: subcategories.length,
                  itemBuilder: (_, i) => _gridCard(
                    icon: subcategories[i].icon,
                    label: subcategories[i].name,
                    onTap: () =>
                        setState(() => _selectedSubcategory = subcategories[i]),
                  ),
                ),
        ),
      ],
    );
  }

  // ── Products in Subcategory Grid ──

  Widget _buildSubcategoryProductsGrid() {
    final products = _selectedSubcategory!.products;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedSubcategory = null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Back to Subcategories',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            _selectedSubcategory!.name,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: products.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) => _productGridCard(products[i]),
                ),
        ),
      ],
    );
  }

  Widget _gridCard({
    required IconData icon,
    required String label,
    String? status,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade700),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            if (status != null) ...[
              const SizedBox(height: 6),
              _statusBadge(status),
            ],
          ],
        ),
      ),
    );
  }

  Widget _productGridCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 50,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        product.code,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _statusBadge(product.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PRODUCT DETAIL BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════

class _ProductDetailSheet extends StatefulWidget {
  final Product product;
  const _ProductDetailSheet({required this.product});

  @override
  State<_ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<_ProductDetailSheet> {
  int _activeTab = 0;
  int _sellPriceSubTab = 0;

  static const _tabLabels = [
    'Identification',
    'Attribute',
    'Dimensions & Weight',
    'Custom Label',
    'Alternative UOM',
    'Sell Price',
    'Phantom BOM',
    'Documentation',
    'Transaction',
    'Where Used',
    'Alternative Products',
    'Audit',
  ];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Product header info
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Product code + badge + image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 30,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    p.code,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildBadge(p.status),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                p.name,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Summary info
                    _infoLine('Segment:', p.segment),
                    _infoLine('Category:', p.category),
                    _infoLine('Subcategory:', p.subcategory),
                    _infoLine('Base UOM:', p.baseUOM),
                    _infoLine('Alternative UOM:', p.alternativeUOM),
                    _infoLine('BOM Type:', p.bomType),
                    _infoLine('Stock Type:', p.stockType),
                    const SizedBox(height: 16),
                    // Tabs
                    _buildDetailTabs(),
                    const SizedBox(height: 16),
                    // Tab content
                    _buildTabContent(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(String status) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTabs() {
    final headerColor = context.watch<AppState>().headerColor;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabLabels.length, (i) {
          final isSelected = _activeTab == i;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = i),
            child: Container(
              padding: const EdgeInsets.only(bottom: 8, right: 20),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(bottom: BorderSide(color: headerColor, width: 2))
                    : null,
              ),
              child: Text(
                _tabLabels[i],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? headerColor : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    final p = widget.product;
    switch (_activeTab) {
      case 0:
        return _buildIdentificationTab(p);
      case 1:
        return _buildAttributeTab(p);
      case 2:
        return _buildDimensionsTab(p);
      case 3:
        return _buildCustomLabelTab();
      case 4:
        return _buildAlternativeUOMTab(p);
      case 5:
        return _buildSellPriceTab(p);
      case 6:
        return _buildPhantomBOMTab(p);
      case 7:
        return _buildDocumentationTab();
      case 8:
        return _buildTransactionTab();
      case 9:
        return _buildWhereUsedTab();
      case 10:
        return _buildAlternativeProductsTab();
      case 11:
        return _buildAuditTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIdentificationTab(Product p) {
    return Column(
      children: [
        _tabRow('Previous System Product Code', p.previousSystemProductCode),
        _tabRow('Unit of Measure Availability', p.unitOfMeasureAvailability),
        _tabRow('Product Type', p.productType),
        _tabRow('Brand', p.brand),
        _tabRow('Brand Model', p.brandModel),
        _tabRow('Drawing Number', p.drawingNumber),
        _tabRow('Internal Notes', p.internalNotes),
      ],
    );
  }

  Widget _buildAttributeTab(Product p) {
    return Column(
      children: [
        _tabRow('GL Type', p.glType),
        _tabRow('BOM Type', p.bomTypeAttr),
        _tabRow('Purchase Method', p.purchaseMethod),
        _tabRow('Available in Variants', p.availableInVariants),
        _tabRow('Item Tracking', p.itemTracking),
        _tabRow('Saleable Item', p.saleableItem),
        _tabRow('Inspection Required', p.inspectionRequired),
        _tabRow('Purchase Group', p.purchaseGroup),
        _tabRow('ABC Classification', p.abcClassification),
        _tabRow('Shell-Life', p.shelfLife),
        _tabRow('Warranty Period', p.warrantyPeriod),
        _tabRow('Obsolete', p.obsolete),
        _tabRow('HS Code', p.hsCode),
        _tabRow('Tags', p.tags),
      ],
    );
  }

  Widget _buildDimensionsTab(Product p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actual Measurement',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _tabRow('Length/Depth', p.actualLength),
        _tabRow('Width', p.actualWidth),
        _tabRow('Height', p.actualHeight),
        _tabRow('Net Weight', p.netWeight),
        _tabRow('Cubic', p.actualCubic),
        const SizedBox(height: 20),
        Text(
          'Package Measurement & Dimensions',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _tabRow('Length/Depth', p.pkgLength),
        _tabRow('Width', p.pkgWidth),
        _tabRow('Height', p.pkgHeight),
        _tabRow('Gross Weight', p.grossWeight),
        _tabRow('Cubic', p.pkgCubic),
        _tabRow('Unit', p.pkgUnit),
      ],
    );
  }

  Widget _buildCustomLabelTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'No custom labels configured',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _tabRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  ALTERNATIVE UOM TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAlternativeUOMTab(Product p) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('UOM Option', style: _tableHeaderStyle()),
              ),
              Expanded(
                flex: 2,
                child: Text('Select UOM', style: _tableHeaderStyle()),
              ),
              Expanded(
                flex: 2,
                child: Text('Code', style: _tableHeaderStyle()),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'UOM Conversion Factor',
                  style: _tableHeaderStyle(),
                ),
              ),
            ],
          ),
        ),
        // Table row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Base UOM', style: _tableCellStyle()),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  p.alternativeUOM.isNotEmpty ? p.alternativeUOM : 'Each',
                  style: _tableCellStyle(),
                ),
              ),
              Expanded(flex: 2, child: Text(p.code, style: _tableCellStyle())),
              Expanded(flex: 2, child: Text('1', style: _tableCellStyle())),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SELL PRICE TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSellPriceTab(Product p) {
    final headerColor = context.watch<AppState>().headerColor;
    return Column(
      children: [
        // Sub-tabs: Summary | Cost Details
        Row(
          children: [
            _buildSubTab('Summary', 0, headerColor),
            _buildSubTab('Cost Details', 1, headerColor),
          ],
        ),
        const SizedBox(height: 12),
        _sellPriceSubTab == 0
            ? _buildSellPriceSummary(p)
            : _buildSellPriceCostDetails(p),
      ],
    );
  }

  Widget _buildSubTab(String label, int index, Color activeColor) {
    final isSelected = _sellPriceSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _sellPriceSubTab = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, right: 20),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: activeColor, width: 2))
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSellPriceSummary(Product p) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Product Code', style: _tableHeaderStyle()),
              ),
              Expanded(flex: 2, child: Text('UOM', style: _tableHeaderStyle())),
              Expanded(
                flex: 1,
                child: Text('Curr.', style: _tableHeaderStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Retail', style: _tableHeaderStyle()),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(p.code, style: _tableCellStyle())),
              Expanded(
                flex: 2,
                child: Text(p.baseUOM, style: _tableCellStyle()),
              ),
              Expanded(flex: 1, child: Text('0', style: _tableCellStyle())),
              Expanded(flex: 1, child: Text('1.00', style: _tableCellStyle())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSellPriceCostDetails(Product p) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Product Code', style: _tableHeaderStyle()),
              ),
              Expanded(flex: 2, child: Text('UOM', style: _tableHeaderStyle())),
              Expanded(
                flex: 1,
                child: Text('Curr.', style: _tableHeaderStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Cost', style: _tableHeaderStyle()),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(p.code, style: _tableCellStyle())),
              Expanded(
                flex: 2,
                child: Text(p.baseUOM, style: _tableCellStyle()),
              ),
              Expanded(flex: 1, child: Text('0', style: _tableCellStyle())),
              Expanded(flex: 1, child: Text('0.00', style: _tableCellStyle())),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  PHANTOM BOM TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhantomBOMTab(Product p) {
    final bomItems = _getMockBOMItems(p);
    if (bomItems.isEmpty) {
      return _buildEmptyTabState(
        'No BOM Items',
        'There is no data on this tab.',
      );
    }
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: _tableHeaderStyle())),
              SizedBox(
                width: 60,
                child: Text('Thumbnail', style: _tableHeaderStyle()),
              ),
              Expanded(child: Text('Product', style: _tableHeaderStyle())),
              SizedBox(
                width: 60,
                child: Text(
                  'Quantity',
                  style: _tableHeaderStyle(),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // Table rows
        ...bomItems.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final item = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text('$idx', style: _tableCellStyle()),
                ),
                Container(
                  width: 50,
                  height: 40,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: 20,
                    color: Colors.grey.shade300,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${item['code']} - ${item['name']}',
                    style: _tableCellStyle(),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    item['qty'] as String,
                    style: _tableCellStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<Map<String, String>> _getMockBOMItems(Product p) {
    if (p.bomType == 'No BOM') return [];
    return [
      {
        'code': 'AFI-000029',
        'name': 'Aluminium Channel 75 x 25 × 1.2 Wall x 6000mm Long',
        'qty': '10.00',
      },
      {
        'code': 'AFI-004006',
        'name':
            'EPS Sandwich Pannel 15kg/cbm 1150 wide x 2000 Long x 75mm Thick - Color White',
        'qty': '4.00',
      },
      {
        'code': 'AFI-003988',
        'name':
            'EPS Sandwich Pannel 15kg/cbm 1150 wide x 2500 Long x 75mm Thick - Color White',
        'qty': '4.00',
      },
      {
        'code': 'AFI-004028',
        'name':
            'EPS Sandwich Pannel 15kg/cbm 1150 wide x 3000 Long x 75mm Thick - Color White',
        'qty': '6.00',
      },
      {
        'code': 'AFI-004190',
        'name':
            'EPS Sandwich Pannel 15kg/cbm 1150 Wide x 3500 Long x 75mm Thick - Color White',
        'qty': '1.00',
      },
      {
        'code': 'AFI-003963',
        'name':
            'EPS Sandwich Pannel 15kg/cbm 1150 wide x 4600 Long x 75mm Thick - Color White',
        'qty': '2.00',
      },
      {
        'code': 'AFI-002067',
        'name': 'Female Beam - Back - 80mm x 80mm x 8075mm Long',
        'qty': '1.00',
      },
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EMPTY STATE TABS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildDocumentationTab() {
    return _buildEmptyTabState(
      'No Documentation Found',
      'There is no data on this tab.',
    );
  }

  Widget _buildTransactionTab() {
    return _buildEmptyTabState(
      'No Transaction Found',
      'There is no data on this tab.',
    );
  }

  Widget _buildWhereUsedTab() {
    return _buildEmptyTabState(
      'No Where Used Found',
      'There is no data on this tab.',
    );
  }

  Widget _buildAlternativeProductsTab() {
    return _buildEmptyTabState(
      'No Alternative Products',
      'There is no data on this tab.',
    );
  }

  Widget _buildAuditTab() {
    return _buildEmptyTabState('No Audit', 'There is no data on this tab.');
  }

  Widget _buildEmptyTabState(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel_outlined, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TABLE HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    );
  }

  TextStyle _tableCellStyle() {
    return GoogleFonts.inter(fontSize: 11, color: AppColors.textPrimary);
  }
}
