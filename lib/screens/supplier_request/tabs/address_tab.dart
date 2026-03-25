import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/address_location_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/request_form_widgets.dart';

/// Address data model
class AddressData {
  String? addressType;
  bool setAsPrimary;
  String? country;
  String? countryCode;
  String? region;
  String? province;
  String? city;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final TextEditingController instructionsController;

  AddressData()
      : addressType = null,
        setAsPrimary = false,
        country = null,
        countryCode = null,
        region = null,
        province = null,
        city = null,
        addressLine1Controller = TextEditingController(),
        addressLine2Controller = TextEditingController(),
        latitudeController = TextEditingController(),
        longitudeController = TextEditingController(),
        instructionsController = TextEditingController();

  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    instructionsController.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      'addressType': addressType,
      'setAsPrimary': setAsPrimary ? 1 : 0,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'province': province,
      'city': city,
      'addressLine1': addressLine1Controller.text,
      'addressLine2': addressLine2Controller.text,
      'latitude': latitudeController.text,
      'longitude': longitudeController.text,
      'instructions': instructionsController.text,
    };
  }
}

class SupplierAddressTab extends StatefulWidget {
  const SupplierAddressTab({super.key});

  @override
  State<SupplierAddressTab> createState() => SupplierAddressTabState();
}

class SupplierAddressTabState extends State<SupplierAddressTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ================= STATE =================
  final List<AddressData> _addresses = [];

  // ================= VALIDATION =================
  List<String> validate() {
    final missing = <String>[];
    // Add validation rules as needed
    return missing;
  }

  // ================= DATA =================
  Map<String, dynamic> getData() {
    return {
      "addresses": _addresses.map((a) => a.toMap()).toList(),
    };
  }

  // ================= ACTIONS =================
  void _addAddress() {
    setState(() {
      _addresses.add(AddressData());
    });
  }

  void _deleteAddress(int index) {
    setState(() {
      _addresses[index].dispose();
      _addresses.removeAt(index);
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Address Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Address Tab records the supplier's address details and information, which helps identify and locate the supplier within the system.",
          ),
          const SizedBox(height: 20),

          // Show Add Address at top only when no addresses exist
          if (_addresses.isEmpty)
            FormAddButton(
              label: "Add Address",
              onPressed: _addAddress,
            ),

          if (_addresses.isNotEmpty) ...[
            ..._addresses.asMap().entries.map((entry) {
              return _buildAddressCard(entry.key, entry.value);
            }),
            // Show Add Address at bottom when addresses exist
            FormAddButton(
              label: "Add Address",
              onPressed: _addAddress,
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddressCard(int index, AddressData address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Address ${index + 1}",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _deleteAddress(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= FORM FIELDS =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= SELECT TYPE =================
                _buildDropdownField(
                  hint: "Select Type",
                  value: address.addressType,
                  items: const ['Registered', 'Warehouse', 'Both'],
                  onChanged: (v) => setState(() => address.addressType = v),
                ),
                const SizedBox(height: 12),

                // ================= SET AS PRIMARY =================
                _buildCheckboxRow(
                  label: "Set As Primary",
                  value: address.setAsPrimary,
                  onChanged: (v) => setState(() => address.setAsPrimary = v ?? false),
                ),
                const SizedBox(height: 16),

                // ================= COUNTRY =================
                _buildCountrySelector(address),
                const SizedBox(height: 12),

                // ================= REGION =================
                _buildLocationSelector(
                  hint: "Select Region",
                  value: address.region,
                  enabled: address.country != null,
                  onTap: address.country != null
                      ? () => _showRegionPicker(address)
                      : null,
                ),
                const SizedBox(height: 12),

                // ================= PROVINCE =================
                _buildLocationSelector(
                  hint: "Select Province",
                  value: address.province,
                  enabled: address.region != null,
                  onTap: address.region != null
                      ? () => _showProvincePicker(address)
                      : null,
                ),
                const SizedBox(height: 12),

                // ================= CITY / TOWN =================
                _buildLocationSelector(
                  hint: "Select City or Town",
                  value: address.city,
                  enabled: address.province != null,
                  onTap: address.province != null
                      ? () => _showCityPicker(address)
                      : null,
                ),
                const SizedBox(height: 12),

                // ================= ADDRESS LINE 1 =================
                _buildTextField(
                  controller: address.addressLine1Controller,
                  hint: "Address Line 1",
                  isRequired: true,
                ),
                const SizedBox(height: 12),

                // ================= ADDRESS LINE 2 =================
                _buildTextField(
                  controller: address.addressLine2Controller,
                  hint: "Address Line 2",
                ),
                const SizedBox(height: 12),

                // ================= LATITUDE & LONGITUDE =================
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: address.latitudeController,
                        hint: "Latitude",
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: address.longitudeController,
                        hint: "Longitude",
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ================= INSTRUCTIONS =================
                _buildTextField(
                  controller: address.instructionsController,
                  hint: "Enter Instructions",
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM FIELD WIDGETS =================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return SizedBox(
      height: maxLines > 1 ? null : 44,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: isRequired ? null : hint,
          label: isRequired
              ? RichText(
                  text: TextSpan(
                    text: hint,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF2181FF)),
                      ),
                    ],
                  ),
                )
              : null,
          hintStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2181FF)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          color: enabled ? Colors.white : Colors.grey.shade100,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                hint,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                maxLines: 1,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
            items: items
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector(AddressData address) {
    return GestureDetector(
      onTap: () => _showCountryPicker(address),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (address.country != null) ...[
              Text(
                _getCountryFlag(address.country!),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.country!,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  "Select Country",
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    );
  }

  String _getCountryFlag(String countryName) {
    final country = AddressLocationData.countries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => {'flag': '🌍'},
    );
    return country['flag'] ?? '🌍';
  }

  void _showCountryPicker(AddressData address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CountryPickerModal(
        selectedCountry: address.country,
        onSelect: (country) {
          setState(() {
            address.country = country['name'];
            address.countryCode = country['code'];
            // Reset dependent fields
            address.region = null;
            address.province = null;
            address.city = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showRegionPicker(AddressData address) {
    final regions = AddressLocationData.getRegions(address.country);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerModal(
        title: "Select Region",
        items: regions,
        selectedItem: address.region,
        onSelect: (region) {
          setState(() {
            address.region = region;
            // Reset dependent fields
            address.province = null;
            address.city = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showProvincePicker(AddressData address) {
    final provinces = AddressLocationData.getProvinces(address.region);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerModal(
        title: "Select Province",
        items: provinces,
        selectedItem: address.province,
        onSelect: (province) {
          setState(() {
            address.province = province;
            // Reset dependent field
            address.city = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCityPicker(AddressData address) {
    final cities = AddressLocationData.getCities(address.province);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerModal(
        title: "Select City or Town",
        items: cities,
        selectedItem: address.city,
        onSelect: (city) {
          setState(() {
            address.city = city;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildLocationSelector({
    required String hint,
    required String? value,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: enabled ? Colors.white : Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? hint,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: value != null ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? const Color(0xFF2181FF) : Colors.grey.shade400,
                width: 2,
              ),
              color: value ? const Color(0xFF2181FF) : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    for (var address in _addresses) {
      address.dispose();
    }
    super.dispose();
  }
}

// ================= COUNTRY PICKER MODAL =================

class _CountryPickerModal extends StatefulWidget {
  final String? selectedCountry;
  final Function(Map<String, String>) onSelect;

  const _CountryPickerModal({
    required this.selectedCountry,
    required this.onSelect,
  });

  @override
  State<_CountryPickerModal> createState() => _CountryPickerModalState();
}

class _CountryPickerModalState extends State<_CountryPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredCountries = AddressLocationData.countries;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = AddressLocationData.countries;
      } else {
        _filteredCountries = AddressLocationData.countries
            .where((c) =>
                c['name']!.toLowerCase().contains(query) ||
                c['code']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "Select Country",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search country...",
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Country list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country['name'] == widget.selectedCountry;
                return GestureDetector(
                  onTap: () => widget.onSelect(country),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2181FF).withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country['name']!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                country['code']!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2181FF),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LOCATION PICKER MODAL (Region, Province, City) =================

class _LocationPickerModal extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final Function(String) onSelect;

  const _LocationPickerModal({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  });

  @override
  State<_LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<_LocationPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Items list
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "No results found",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item == widget.selectedItem;
                      return GestureDetector(
                        onTap: () => widget.onSelect(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2181FF).withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF2181FF),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
