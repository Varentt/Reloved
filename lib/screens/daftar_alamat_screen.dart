import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class DaftarAlamatScreen extends StatefulWidget {
  const DaftarAlamatScreen({super.key});

  @override
  State<DaftarAlamatScreen> createState() => _DaftarAlamatScreenState();
}

class _DaftarAlamatScreenState extends State<DaftarAlamatScreen> {
  final List<Map<String, dynamic>> _alamatList = [
    {
      'label': 'Rumah',
      'nama': 'Nama Lengkap',
      'telepon': '08123456789',
      'alamat': 'Jl. Contoh No. 12, Kelurahan Contoh, Kecamatan Contoh',
      'kota': 'Jember, Jawa Timur 68111',
      'utama': true,
    },
    {
      'label': 'Kantor',
      'nama': 'Nama Lengkap',
      'telepon': '08987654321',
      'alamat': 'Jl. Kantor No. 5, Gedung A Lantai 3',
      'kota': 'Jember, Jawa Timur 68121',
      'utama': false,
    },
  ];

  void _showTambahAlamatDialog({int? editIndex}) {
    final labelCtrl =
        TextEditingController(text: editIndex != null ? _alamatList[editIndex]['label'] : '');
    final namaCtrl =
        TextEditingController(text: editIndex != null ? _alamatList[editIndex]['nama'] : '');
    final telCtrl =
        TextEditingController(text: editIndex != null ? _alamatList[editIndex]['telepon'] : '');
    final alamatCtrl =
        TextEditingController(text: editIndex != null ? _alamatList[editIndex]['alamat'] : '');
    final kotaCtrl =
        TextEditingController(text: editIndex != null ? _alamatList[editIndex]['kota'] : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  editIndex != null ? 'Edit Alamat' : 'Tambah Alamat Baru',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _textPrimary),
                ),
                const SizedBox(height: 20),
                _buildField('Label Alamat (contoh: Rumah)', labelCtrl),
                const SizedBox(height: 12),
                _buildField('Nama Penerima', namaCtrl),
                const SizedBox(height: 12),
                _buildField('No. Telepon', telCtrl, type: TextInputType.phone),
                const SizedBox(height: 12),
                _buildField('Alamat Lengkap', alamatCtrl, maxLines: 2),
                const SizedBox(height: 12),
                _buildField('Kota & Kode Pos', kotaCtrl),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (labelCtrl.text.isEmpty || alamatCtrl.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        final newAlamat = {
                          'label': labelCtrl.text,
                          'nama': namaCtrl.text,
                          'telepon': telCtrl.text,
                          'alamat': alamatCtrl.text,
                          'kota': kotaCtrl.text,
                          'utama': editIndex != null
                              ? _alamatList[editIndex]['utama']
                              : false,
                        };
                        if (editIndex != null) {
                          _alamatList[editIndex] = newAlamat;
                        } else {
                          _alamatList.add(newAlamat);
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      editIndex != null ? 'Simpan Perubahan' : 'Tambah Alamat',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController ctrl,
      {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  void _setUtama(int index) {
    setState(() {
      for (int i = 0; i < _alamatList.length; i++) {
        _alamatList[i]['utama'] = i == index;
      }
    });
  }

  void _hapusAlamat(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Alamat',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: _primary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _alamatList.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryDark, _primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: _primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Alamat',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahAlamatDialog(),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Alamat',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: _alamatList.isEmpty
          ? const Center(
              child: Text('Belum ada alamat tersimpan',
                  style: TextStyle(color: _textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: _alamatList.length,
              itemBuilder: (context, index) {
                final item = _alamatList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: item['utama']
                        ? Border.all(color: _primary, width: 1.5)
                        : null,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['utama']
                                      ? _primary
                                      : _accent.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item['label'],
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: item['utama']
                                          ? Colors.white
                                          : _primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (item['utama']) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Utama',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: _primary, size: 18),
                              onPressed: () =>
                                  _showTambahAlamatDialog(editIndex: index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 18),
                              onPressed: () => _hapusAlamat(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(item['nama'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _textPrimary)),
                        const SizedBox(height: 2),
                        Text(item['telepon'],
                            style: const TextStyle(
                                fontSize: 12, color: _textSecondary)),
                        const SizedBox(height: 6),
                        Text(item['alamat'],
                            style: const TextStyle(
                                fontSize: 13, color: _textPrimary)),
                        Text(item['kota'],
                            style: const TextStyle(
                                fontSize: 12, color: _textSecondary)),
                        if (!item['utama']) ...[
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _setUtama(index),
                            child: Text(
                              'Jadikan Alamat Utama',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _primary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}