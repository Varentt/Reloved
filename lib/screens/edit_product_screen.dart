import 'package:flutter/material.dart';
import 'package:reloved/utils/color_resources.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _normalPriceController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedType;

  final List<String> _productTypes = [
    'Pakaian',
    'Elektronik',
    'Makanan',
    'Aksesoris',
    'Peralatan Rumah Tangga',
    'Lainnya',
  ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Foto Placeholder
            const Text(
              'Foto Produk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: Implementasi ambil gambar dari galeri/kamera nanti
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambah Foto',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nama Barang
            _buildLabel('Nama Barang'),
            TextField(
              controller: _nameController,
              decoration: _buildInputDecoration('Contoh: Sepatu Sneaker Nike'),
            ),

            const SizedBox(height: 16),

            _buildLabel('Harga Normal (Rp)'),
            TextField(
              controller: _normalPriceController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration(
                'Contoh: 250000',
              ),
            ),

            const SizedBox(height: 16),
            // Harga
            _buildLabel('Harga Jual (Rp)'),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Contoh: 150000'),
            ),

            const SizedBox(height: 16),

            _buildLabel('Jenis Produk'),

            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: _buildInputDecoration(
                'Pilih Jenis Produk',
              ),
              items: _productTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Kategori Dropdown
            _buildLabel('Kategori'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _buildInputDecoration('Pilih Kategori'),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),

            const SizedBox(height: 16),

            // Kondisi Dropdown
            _buildLabel('Kondisi'),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: _buildInputDecoration('Pilih Kondisi'),
              items: _conditions
                  .map((con) => DropdownMenuItem(value: con, child: Text(con)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCondition = val),
            ),

            const SizedBox(height: 16),

            if (_selectedCategory == 'Makanan Hampir Expired') ...[
              const SizedBox(height: 16),

              _buildLabel('Tanggal Kedaluwarsa'),

              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2035),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _expiredDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _expiredDate == null
                        ? 'Pilih Tanggal Kedaluwarsa'
                        : '${_expiredDate!.day}/${_expiredDate!.month}/${_expiredDate!.year}',
                  ),
                ),
              ),
            ],
            // Lokasi
            _buildLabel('Lokasi'),
            TextField(
              controller: _locationController,
              decoration: _buildInputDecoration('Contoh: Malang, Jawa Timur'),
            ),

            const SizedBox(height: 16),

            // Deskripsi
            _buildLabel('Deskripsi'),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _buildInputDecoration(
                'Ceritakan detail barang anda...',
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Simpan ke Firestore di Fase 4
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk anda berhasil diiklankan!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
