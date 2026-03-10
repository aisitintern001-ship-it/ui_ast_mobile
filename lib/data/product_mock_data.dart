import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  PRODUCT MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════

class ProductSegment {
  final String id;
  final String name;
  final IconData icon;
  final String status;
  final List<ProductCategory> categories;

  const ProductSegment({
    required this.id,
    required this.name,
    required this.icon,
    this.status = 'Active',
    required this.categories,
  });
}

class ProductCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<ProductSubcategory> subcategories;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.subcategories,
  });
}

class ProductSubcategory {
  final String id;
  final String name;
  final IconData icon;
  final List<Product> products;

  const ProductSubcategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.products,
  });
}

class Product {
  final String code;
  final String name;
  final String status;
  final String segment;
  final String category;
  final String subcategory;
  final String baseUOM;
  final String alternativeUOM;
  final String bomType;
  final String stockType;
  final int sohWHS;
  final int sohOO;
  final int sohOT;
  final int sohWHSO;
  final int sohIT;
  // Identification
  final String previousSystemProductCode;
  final String unitOfMeasureAvailability;
  final String productType;
  final String brand;
  final String brandModel;
  final String drawingNumber;
  final String internalNotes;
  // Attribute
  final String glType;
  final String bomTypeAttr;
  final String purchaseMethod;
  final String availableInVariants;
  final String itemTracking;
  final String saleableItem;
  final String inspectionRequired;
  final String purchaseGroup;
  final String abcClassification;
  final String shelfLife;
  final String warrantyPeriod;
  final String obsolete;
  final String hsCode;
  final String tags;
  // Dimensions
  final String actualLength;
  final String actualWidth;
  final String actualHeight;
  final String netWeight;
  final String actualCubic;
  final String pkgLength;
  final String pkgWidth;
  final String pkgHeight;
  final String grossWeight;
  final String pkgCubic;
  final String pkgUnit;

  const Product({
    required this.code,
    required this.name,
    this.status = 'Active',
    required this.segment,
    required this.category,
    required this.subcategory,
    this.baseUOM = 'Each',
    this.alternativeUOM = 'None',
    this.bomType = 'No BOM',
    this.stockType = 'Stock',
    this.sohWHS = 0,
    this.sohOO = 0,
    this.sohOT = 0,
    this.sohWHSO = 0,
    this.sohIT = 0,
    this.previousSystemProductCode = 'None',
    this.unitOfMeasureAvailability = 'None',
    this.productType = 'Stock',
    this.brand = '--',
    this.brandModel = '--',
    this.drawingNumber = '--',
    this.internalNotes = '--',
    this.glType = 'None',
    this.bomTypeAttr = 'None',
    this.purchaseMethod = 'Stock',
    this.availableInVariants = '--',
    this.itemTracking = '--',
    this.saleableItem = '--',
    this.inspectionRequired = '--',
    this.purchaseGroup = '--',
    this.abcClassification = '--',
    this.shelfLife = '--',
    this.warrantyPeriod = '--',
    this.obsolete = '--',
    this.hsCode = '--',
    this.tags = '--',
    this.actualLength = '- mm',
    this.actualWidth = '- mm',
    this.actualHeight = '- mm',
    this.netWeight = '- kg',
    this.actualCubic = '- m³',
    this.pkgLength = '- mm',
    this.pkgWidth = '- mm',
    this.pkgHeight = '- mm',
    this.grossWeight = '- kg',
    this.pkgCubic = '- m³',
    this.pkgUnit = '-',
  });
}

class ProductMockData {
  static const _seg1 = 'Prefab Poultry Building Quote Assemblies';
  static const _seg2 = 'Ventilation Systems';
  static const _seg3 = 'Building & Construction Materials';

  static const _cat1 = 'Prefab Poultry Building Main Steel Assemblies';
  static const _cat2 = 'Prefab Poultry Building Ancillary Structures';
  static const _cat3 = 'Prefab Poultry Building Finishing Kits';
  static const _cat4 = 'Prefab Poultry Building Finishing Kits';
  static const _cat5 = 'Poultry House Retrofit Kits';

  static const _sub1 = 'Wall, Roof & Ceiling Kits';
  static const _sub2 = 'Non Fan End Wall & Feed Bodega Wall Kits';
  static const _sub3 = 'Roofing Kits';
  static const _sub4 = 'Ceiling Kits';
  static const _sub5 = 'Door Kits';
  static const _sub6 = 'Installed Cellulose Insulation';
  static const _sub7 = 'Window Kits';
  static const _sub8 = 'Fan End Wall Kits';

  static final List<Product> allProducts = [
    Product(
      code: 'AFI-012990',
      name: 'Prefab Building End Wall (Fan End) Kit - for 15m Wide x 4.5m Side Wall Height Building, with 14 off MagFans, 75mm Thick EPS Panels',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub8,
      baseUOM: 'Set',
      alternativeUOM: 'Each',
    ),
    Product(
      code: 'AFI-012991',
      name: 'Maxx Honey Eucalyptus',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub1,
      alternativeUOM: 'Box',
    ),
    Product(
      code: 'AFI-012992',
      name: 'X.O. Coffee Candy',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub1,
      alternativeUOM: 'Box',
    ),
    Product(
      code: 'AFI-012993',
      name: 'Prefab Building Side Wall Kit - 18m Wide x 5.0m Height with EPS Panels',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub1,
    ),
    Product(
      code: 'AFI-012921',
      name: 'Prefab Building End Wall with Cooling Pad (Non-Fan End) - for 18m Wide x 3.8m H...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-012394',
      name: 'Prefab Building End Wall with Cooling Pad (Non-Fan End) - with Front Cooling Pa...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-012069',
      name: 'Prefab Building End Wall with No Cooling Pad (Non-Fan End) - for 18m Wide x 5.0m H...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-011561',
      name: 'Prefab Building End Wall (Full EPS No Opening) Kit - for 18.475m Wide x 4.4m Side Wall He...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-011511',
      name: 'Prefab Building End Wall with Cooling Pad (Non-Fan End) - for 15m Wide x 4.5m Hig...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-011438',
      name: 'Prefab Building End Wall with Cooling Pad (Non-Fan End) - for 20m Wide x 2.2m H...',
      segment: _seg1,
      category: _cat3,
      subcategory: _sub2,
    ),
    Product(
      code: 'AFI-013001',
      name: 'Ventilation Fan Assembly - 1.2m Diameter Industrial Grade',
      segment: _seg2,
      category: 'Industrial Fans',
      subcategory: 'Exhaust Fans',
    ),
    Product(
      code: 'AFI-013002',
      name: 'Air Circulation System - Complete Kit for 500sqm',
      segment: _seg2,
      category: 'Industrial Fans',
      subcategory: 'Circulation Fans',
    ),
    Product(
      code: 'AFI-013010',
      name: 'Structural Steel Beam - H-Shape 200x200mm',
      segment: _seg3,
      category: 'Structural Steel',
      subcategory: 'Beams',
    ),
    Product(
      code: 'AFI-013011',
      name: 'Concrete Mix - High Strength Grade 40',
      segment: _seg3,
      category: 'Concrete Products',
      subcategory: 'Ready Mix',
    ),
  ];

  static final List<ProductSegment> segments = [
    ProductSegment(
      id: 'seg1',
      name: _seg1,
      icon: Icons.warehouse_outlined,
      categories: [
        ProductCategory(
          id: 'cat1',
          name: _cat1,
          icon: Icons.foundation_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub_steel1',
              name: 'Main Steel Frames',
              icon: Icons.view_column_outlined,
              products: [],
            ),
          ],
        ),
        ProductCategory(
          id: 'cat2',
          name: _cat2,
          icon: Icons.air_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub_anc1',
              name: 'Support Structures',
              icon: Icons.architecture_outlined,
              products: [],
            ),
          ],
        ),
        ProductCategory(
          id: 'cat3',
          name: _cat3,
          icon: Icons.roofing_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub1',
              name: _sub1,
              icon: Icons.layers_outlined,
              products: allProducts.where((p) => p.subcategory == _sub1 && p.category == _cat3).toList(),
            ),
            ProductSubcategory(
              id: 'sub2',
              name: _sub2,
              icon: Icons.grid_view_outlined,
              products: allProducts.where((p) => p.subcategory == _sub2).toList(),
            ),
            ProductSubcategory(
              id: 'sub3',
              name: _sub3,
              icon: Icons.roofing_outlined,
              products: [],
            ),
            ProductSubcategory(
              id: 'sub4',
              name: _sub4,
              icon: Icons.view_agenda_outlined,
              products: [],
            ),
            ProductSubcategory(
              id: 'sub5',
              name: _sub5,
              icon: Icons.door_front_door_outlined,
              products: [],
            ),
            ProductSubcategory(
              id: 'sub6',
              name: _sub6,
              icon: Icons.inventory_2_outlined,
              products: [],
            ),
            ProductSubcategory(
              id: 'sub7',
              name: _sub7,
              icon: Icons.window_outlined,
              products: [],
            ),
            ProductSubcategory(
              id: 'sub8',
              name: _sub8,
              icon: Icons.layers_outlined,
              products: allProducts.where((p) => p.subcategory == _sub8).toList(),
            ),
          ],
        ),
        ProductCategory(
          id: 'cat4',
          name: _cat4,
          icon: Icons.home_repair_service_outlined,
          subcategories: [],
        ),
        ProductCategory(
          id: 'cat5',
          name: _cat5,
          icon: Icons.build_outlined,
          subcategories: [],
        ),
      ],
    ),
    ProductSegment(
      id: 'seg2',
      name: _seg2,
      icon: Icons.air_outlined,
      categories: [
        ProductCategory(
          id: 'cat_vent1',
          name: 'Industrial Fans',
          icon: Icons.air_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub_exh',
              name: 'Exhaust Fans',
              icon: Icons.air_outlined,
              products: allProducts.where((p) => p.subcategory == 'Exhaust Fans').toList(),
            ),
            ProductSubcategory(
              id: 'sub_circ',
              name: 'Circulation Fans',
              icon: Icons.air_outlined,
              products: allProducts.where((p) => p.subcategory == 'Circulation Fans').toList(),
            ),
          ],
        ),
      ],
    ),
    ProductSegment(
      id: 'seg3',
      name: _seg3,
      icon: Icons.construction_outlined,
      categories: [
        ProductCategory(
          id: 'cat_steel',
          name: 'Structural Steel',
          icon: Icons.view_column_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub_beams',
              name: 'Beams',
              icon: Icons.view_column_outlined,
              products: allProducts.where((p) => p.subcategory == 'Beams').toList(),
            ),
          ],
        ),
        ProductCategory(
          id: 'cat_conc',
          name: 'Concrete Products',
          icon: Icons.square_outlined,
          subcategories: [
            ProductSubcategory(
              id: 'sub_ready',
              name: 'Ready Mix',
              icon: Icons.square_outlined,
              products: allProducts.where((p) => p.subcategory == 'Ready Mix').toList(),
            ),
          ],
        ),
      ],
    ),
  ];

  static List<String> get allSegmentNames => segments.map((s) => s.name).toList();
  static List<String> get allCategoryNames => segments.expand((s) => s.categories.map((c) => c.name)).toSet().toList();
  static List<String> get allSubcategoryNames => segments.expand((s) => s.categories.expand((c) => c.subcategories.map((sc) => sc.name))).toSet().toList();
  static List<String> get allBrands => ['AFI', 'Maxx', 'Generic'];
  static List<String> get allUOMs => ['Each', 'Set', 'Box', 'Pack', 'Unit'];
  static List<String> get allProductTypes => ['Stock', 'Non-Stock', 'Service'];
  static List<String> get allStatuses => ['Active', 'Inactive'];
}
