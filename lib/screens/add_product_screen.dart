import 'package:flutter/material.dart';

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
  int _stok = 1; // stok default 1

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
      backgroundColor: _surface,
      body: SafeArea(
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
                  const Text(
                    'Tambah Produk',
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
                      onTap: () {
                        // TODO: Implementasi ambil gambar
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _accent),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: _primary),
                            SizedBox(height: 8),
                            Text('Tambah Foto', style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
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

                    // ── Jumlah Stok ──
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
                          const Icon(Icons.inventory_2_outlined, size: 18, color: _primary),
                          const SizedBox(width: 10),
                          const Text('Stok tersedia',
                              style: TextStyle(fontSize: 13, color: _textSecondary)),
                          const Spacer(),
                          // Tombol kurang
                          GestureDetector(
                            onTap: () {
                              if (_stok > 1) setState(() => _stok--);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _stok > 1 ? _accent : _accent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.remove,
                                  size: 16,
                                  color: _stok > 1 ? _primary : _textSecondary),
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
                          // Tombol tambah
                          GestureDetector(
                            onTap: () => setState(() => _stok++),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _accent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add, size: 16, color: _primary),
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

                    // Tanggal Kedaluwarsa (hanya muncul jika kategori Makanan)
                    if (_selectedCategory == 'Makanan Hampir Expired') ...[
                      const SizedBox(height: 14),
                      _buildLabel('Tanggal Kedaluwarsa'),
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(primary: _primary),
                              ),
                              child: child!,
                            ),
                          );
                          if (pickedDate != null) {
                            setState(() => _expiredDate = pickedDate);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: _accent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 18, color: _primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _expiredDate == null
                                      ? 'Pilih Tanggal Kedaluwarsa'
                                      : '${_expiredDate!.day}/${_expiredDate!.month}/${_expiredDate!.year}',
                                  style: TextStyle(
                                    color: _expiredDate == null ? _textSecondary : _textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Lokasi
                    _buildLabel('Lokasi'),
                    _buildTextField(_locationController, 'Contoh: Malang, Jawa Timur'),

                    const SizedBox(height: 14),

                    // Deskripsi
                    _buildLabel('Deskripsi'),
                    _buildTextField(
                      _descriptionController,
                      'Ceritakan detail barang anda...',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 28),

                    // Tombol Submit
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Simpan ke backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Produk berhasil ditambahkan!'),
                              backgroundColor: _primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Pasang Iklan Sekarang',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary),
      ),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item,
                  style: const TextStyle(fontSize: 14, color: _textPrimary))))
          .toList(),
      onChanged: onChanged,
    );
  }
}