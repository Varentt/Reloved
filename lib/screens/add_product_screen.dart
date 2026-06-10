import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/product_service.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _normalPriceController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  int _stok = 1; 
  bool _isLoading = false;
  
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _selectedCategory;
  String? _selectedCondition;
  DateTime? _expiredDate;
  final List<String> _categories = [
    'Barang Second',
    'Produk Reject',
    'Makanan Hampir Expired',
  ];
  final List<String> _conditions = [
    'Sangat Baik',
    'Baik',
    'Cukup',
    'Ada Minus',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _normalPriceController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // 📸 FUNGSI AMBIL FOTO
  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => _imageFile = selected);
    }
  }

  // 📍 FUNGSI AMBIL LOKASI (GPS)
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => _isLoading = true);

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS anda tidak aktif';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak';
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      
      // Ubah koordinat jadi nama kota (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _locationController.text = "${place.locality}, ${place.subAdministrativeArea}";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ambil lokasi: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSubmit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login dulu')));
      return;
    }

    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi data wajib (Nama, Harga, Kategori)')));
      return;
    }

    setState(() => _isLoading = true);

    // MOCK: Sementara imageUrl kosong karena perlu Firebase Storage setup
    final product = ProductModel(
      id: '', 
      ownerId: user.uid,
      name: _nameController.text.trim(),
      price: int.parse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      normalPrice: int.tryParse(_normalPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      category: _selectedCategory!,
      condition: _selectedCondition ?? 'Baik',
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: '', 
      status: 'Aktif',
      createdAt: DateTime.now(),
    );

    final error = await ProductService().addProduct(product);

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil diiklankan!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ── AppBar ──
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryDark, _primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text('Tambah Produk', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Foto Produk'),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _accent),
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, size: 40, color: _primary),
                                      SizedBox(height: 8),
                                      Text('Tambah Foto dari Galeri', style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildLabel('Nama Barang'),
                        _buildTextField(_nameController, 'Contoh: Sepatu Sneaker Nike'),

                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _buildLabel('Harga Jual'),
                              _buildTextField(_priceController, '150000', isNumber: true),
                            ])),
                            const SizedBox(width: 16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _buildLabel('Harga Normal'),
                              _buildTextField(_normalPriceController, '200000', isNumber: true),
                            ])),
                          ],
                        ),

                        const SizedBox(height: 14),
                        _buildLabel('Kategori'),
                        _buildDropdown(
                          value: _selectedCategory,
                          hint: 'Pilih Kategori',
                          items: _categories,
                          onChanged: (val) => setState(() => _selectedCategory = val),
                        ),

                        const SizedBox(height: 14),
                        _buildLabel('Lokasi Pengambilan'),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_locationController, 'Klik tombol di samping ->')),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: _getCurrentLocation,
                              icon: const Icon(Icons.my_location, color: _primary),
                              style: IconButton.styleFrom(backgroundColor: _accent.withOpacity(0.5)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        _buildLabel('Deskripsi'),
                        _buildTextField(_descriptionController, 'Ceritakan detail barang anda...', maxLines: 4),

                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Pasang Iklan Sekarang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: _primary))),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: _textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14, color: _textPrimary)))).toList(),
      onChanged: onChanged,
    );
  }
}
