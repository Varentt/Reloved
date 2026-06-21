import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/services/product_service.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _normalPriceController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  String? _selectedCategory;
  String? _selectedCondition;
  int _stok = 1;
  bool _isLoading = false;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Elektronik',
    'Pakaian',
    'Peralatan',
    'Lainnya',
  ];
  final List<String> _conditions = [
    'Sangat Baik',
    'Baik',
    'Cukup',
    'Ada Minus',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _normalPriceController = TextEditingController(text: widget.product.normalPrice.toString());
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _locationController = TextEditingController(text: widget.product.location);
    _selectedCategory = widget.product.category;
    _selectedCondition = widget.product.condition;
    _stok = widget.product.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _normalPriceController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // 📸 FUNGSI PILIH SUMBER FOTO (KAMERA / GALERI)
  Future<void> _pilihSumberFoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubah Foto Produk',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _ambilFoto(ImageSource.camera);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _accent.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.camera_alt, color: _primary, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'Kamera',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _ambilFoto(ImageSource.gallery);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _accent.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.photo_library, color: _primary, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'Galeri',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ambilFoto(ImageSource source) async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (selected != null) {
        setState(() => _imageFile = selected);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  Future<void> _handleUpdate() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi data wajib (Nama, Harga, Kategori)')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String imageUrl = widget.product.imageUrl;

      // Jika user memilih gambar baru, upload ke Storage
      if (_imageFile != null) {
        Uint8List? webBytes;
        if (kIsWeb) {
          webBytes = await _imageFile!.readAsBytes();
        }
        final uploadedUrl = await ProductService().uploadProductImage(
          ownerId: widget.product.ownerId,
          filePath: _imageFile!.path,
          webBytes: webBytes,
        );
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengunggah foto produk')),
          );
          return;
        }
      }

      final updatedProduct = ProductModel(
        id: widget.product.id,
        ownerId: widget.product.ownerId,
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        normalPrice: int.tryParse(_normalPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        category: _selectedCategory!,
        condition: _selectedCondition ?? 'Baik',
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
        status: 'Pending', // Mengirim kembali untuk verifikasi admin setelah di-edit
        createdAt: widget.product.createdAt,
        stock: _stok,
      );

      final error = await ProductService().updateProduct(updatedProduct);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil diperbarui! Menunggu konfirmasi admin.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                // ── AppBar gradient ──
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
                      const Text(
                        'Edit Produk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Upload Foto
                        _buildLabel('Foto Produk'),
                        GestureDetector(
                          onTap: _pilihSumberFoto,
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
                                    child: kIsWeb
                                        ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                                        : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                                  )
                                : (widget.product.imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(widget.product.imageUrl, fit: BoxFit.cover),
                                      )
                                    : const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo_outlined, size: 40, color: _primary),
                                          SizedBox(height: 8),
                                          Text('Ubah Foto Produk (Kamera / Galeri)',
                                              style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
                                        ],
                                      )),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Nama Barang
                        _buildLabel('Nama Barang'),
                        _buildTextField(_nameController, 'Contoh: Sepatu Sneaker Nike'),

                        const SizedBox(height: 14),

                        // Harga Normal
                        _buildLabel('Harga Normal (Rp)'),
                        _buildTextField(_normalPriceController, 'Contoh: 250000', isNumber: true),

                        const SizedBox(height: 14),

                        // Harga Jual
                        _buildLabel('Harga Jual (Rp)'),
                        _buildTextField(_priceController, 'Contoh: 150000', isNumber: true),

                        const SizedBox(height: 14),

                        // Jumlah Stok
                        _buildLabel('Jumlah Stok'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: _accent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory_outlined, size: 18, color: _primary),
                              const SizedBox(width: 10),
                              const Text('Stok tersedia',
                                  style: TextStyle(fontSize: 13, color: _textSecondary)),
                              const Spacer(),
                              GestureDetector(
                                onTap: _stok > 1 ? () => setState(() => _stok--) : null,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _stok > 1 ? _primary : _accent.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.remove,
                                      size: 16,
                                      color: _stok > 1 ? Colors.white : _textSecondary),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$_stok',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: _textPrimary),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _stok++),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Kategori
                        _buildLabel('Kategori'),
                        _buildDropdown(
                          value: _selectedCategory,
                          hint: 'Pilih Kategori',
                          items: _categories,
                          onChanged: (val) => setState(() => _selectedCategory = val),
                        ),

                        const SizedBox(height: 14),

                        // Kondisi
                        _buildLabel('Kondisi'),
                        _buildDropdown(
                          value: _selectedCondition,
                          hint: 'Pilih Kondisi',
                          items: _conditions,
                          onChanged: (val) => setState(() => _selectedCondition = val),
                        ),

                        const SizedBox(height: 14),

                        // Lokasi
                        _buildLabel('Lokasi'),
                        _buildTextField(
                          _locationController,
                          'Contoh: Malang, Jawa Timur',
                          maxLines: 3,
                        ),

                        const SizedBox(height: 14),

                        // Deskripsi
                        _buildLabel('Deskripsi'),
                        _buildTextField(
                          _descriptionController,
                          'Ceritakan detail barang anda...',
                          maxLines: 4,
                        ),

                        const SizedBox(height: 28),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleUpdate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Simpan Perubahan',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),

                        const SizedBox(height: 32),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, int maxLines = 1}) {
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
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary, width: 1.5)),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _accent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary, width: 1.5)),
      ),
      items: items
          .map((item) => DropdownMenuItem(
              value: item, child: Text(item, style: const TextStyle(fontSize: 14, color: _textPrimary))))
          .toList(),
      onChanged: onChanged,
    );
  }
}