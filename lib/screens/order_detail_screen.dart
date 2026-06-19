import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reloved/models/order_model.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/models/user_model.dart';
import 'package:reloved/services/auth_service.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/services/order_service.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  final String type; // 'pembelian' atau 'penjualan'

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.type,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _currentStatus;
  late final Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
    _detailsFuture = _fetchDetails();
  }

  Future<Map<String, dynamic>> _fetchDetails() async {
    final results = await Future.wait([
      AuthService().getUserData(widget.order.buyerId),
      AuthService().getUserData(widget.order.sellerId),
      ProductService().getProductById(widget.order.productId),
    ]);
    return {
      'buyer': results[0] as UserModel?,
      'seller': results[1] as UserModel?,
      'product': results[2] as ProductModel?,
    };
  }

  final List<String> _statusFlowPembelian = [
    'Menunggu Konfirmasi',
    'Dikemas',
    'Dikirim',
    'Selesai',
  ];

  final List<String> _statusFlowPenjualan = [
    'Pesanan Masuk',
    'Dikemas',
    'Dikirim',
    'Selesai',
  ];

  List<String> get _statusFlow => widget.type == 'pembelian'
      ? _statusFlowPembelian
      : _statusFlowPenjualan;

  int get _statusIndex {
    switch (_currentStatus) {
      case 'Diproses': return 1;
      case 'Dikirim': return 2;
      case 'Selesai': return 3;
      case 'Pending':
      default:
        return 0;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai': return Colors.green;
      case 'Dikirim': return Colors.blue;
      case 'Diproses': return Colors.orange;
      case 'Pending': return Colors.orange;
      case 'Batal': return Colors.red;
      default: return _textSecondary;
    }
  }

  void _showKonfirmasiTerima() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pesanan Diterima',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
        content: const Text('Apakah kamu sudah menerima barang dengan kondisi baik?',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await OrderService().updateOrderStatus(widget.order.id, 'Selesai');
              setState(() => _currentStatus = 'Selesai');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan telah dikonfirmasi selesai!'),
                      backgroundColor: Color(0xFF2e7d32)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e7d32),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Diterima'),
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiPesanan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Pesanan',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
        content: const Text('Konfirmasi bahwa kamu menerima pesanan ini dan siap mengemas barang?',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await OrderService().updateOrderStatus(widget.order.id, 'Diproses');
              setState(() => _currentStatus = 'Diproses');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan berhasil dikonfirmasi dan sedang dikemas!'),
                      backgroundColor: Colors.orange),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Konfirmasi & Kemas'),
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiKirim() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kirim Barang',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
        content: const Text('Konfirmasi bahwa kamu sudah mengirimkan barang ke pembeli?',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await OrderService().updateOrderStatus(widget.order.id, 'Dikirim');
              setState(() => _currentStatus = 'Dikirim');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barang berhasil dikonfirmasi dikirim!'),
                      backgroundColor: _primary),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Dikirim'),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

  void _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await OrderService().updateOrderStatus(widget.order.id, 'Batal');
      
      // Restore stock in Supabase
      try {
        final pService = ProductService();
        final prod = await pService.getProductById(widget.order.productId);
        if (prod != null) {
          final newStock = prod.stock + widget.order.qty;
          final updatedProd = ProductModel(
            id: prod.id,
            ownerId: prod.ownerId,
            name: prod.name,
            price: prod.price,
            normalPrice: prod.normalPrice,
            category: prod.category,
            condition: prod.condition,
            location: prod.location,
            description: prod.description,
            imageUrl: prod.imageUrl,
            status: prod.status == 'Terjual' ? 'Aktif' : prod.status,
            stock: newStock,
            createdAt: prod.createdAt,
          );
          await pService.updateProduct(updatedProd);
        }
      } catch (e) {
        debugPrint("Gagal mengembalikan stok produk: $e");
      }

      setState(() => _currentStatus = 'Batal');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dibatalkan'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPembelian = widget.type == 'pembelian';
    final statusColor = _statusColor(_currentStatus);
    final invNumber = 'INV/${widget.order.createdAt.year}/${widget.order.createdAt.month}/${widget.order.id.substring(0, 5).toUpperCase()}';
    final dateStr = '${widget.order.createdAt.day}/${widget.order.createdAt.month}/${widget.order.createdAt.year}';

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
                  const Text('Detail Pesanan',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),

            // ── Body ──
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _detailsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: _primary));
                  }
                  
                  final details = snapshot.data ?? {};
                  final buyer = details['buyer'] as UserModel?;
                  final seller = details['seller'] as UserModel?;
                  final product = details['product'] as ProductModel?;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Nomor Invoice & Status ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Nomor Invoice', style: TextStyle(fontSize: 11, color: _textSecondary)),
                                      const SizedBox(height: 2),
                                      Text(invNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: statusColor.withOpacity(0.3)),
                                    ),
                                    child: Text(_currentStatus,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Tanggal: $dateStr', style: const TextStyle(fontSize: 12, color: _textSecondary)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Progress Status ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Status Pesanan',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 16),
                              Row(
                                children: List.generate(_statusFlow.length, (i) {
                                  final isActive = i <= _statusIndex;
                                  final isLast = i == _statusFlow.length - 1;
                                  return Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 28, height: 28,
                                                decoration: BoxDecoration(
                                                  color: isActive ? _primary : _surface,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: isActive ? _primary : _accent, width: 2),
                                                ),
                                                child: Icon(_statusIcon(i), size: 14,
                                                    color: isActive ? Colors.white : _textSecondary),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(_statusFlow[i],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                                                      color: isActive ? _primary : _textSecondary)),
                                            ],
                                          ),
                                        ),
                                        if (!isLast)
                                          Expanded(
                                            child: Container(
                                              height: 2,
                                              margin: const EdgeInsets.only(bottom: 22),
                                              color: i < _statusIndex ? _primary : _accent,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Info Produk ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Info Produk',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 72, height: 72,
                                    decoration: BoxDecoration(
                                      color: _accent.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: product != null && product.imageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(product.imageUrl, fit: BoxFit.cover),
                                          )
                                        : const Icon(Icons.image_outlined, color: _textSecondary, size: 30),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.order.productName,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                                        const SizedBox(height: 4),
                                        Text(
                                          isPembelian ? 'Penjual: ${seller?.name ?? "Memuat..."}' : 'Pembeli: ${buyer?.name ?? "Memuat..."}',
                                          style: const TextStyle(fontSize: 12, color: _textSecondary),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(_formatRupiah(widget.order.price),
                                            style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 16)),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _accent.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.shopping_bag_outlined, size: 13, color: _primary),
                                              const SizedBox(width: 5),
                                              Text('Jumlah: ${widget.order.qty} item',
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _primary)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Info Pengiriman ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Info Pengiriman',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 12),
                              if (isPembelian) ...[
                                _DetailRow(icon: Icons.location_on_outlined, label: 'Lokasi Penjual', value: product?.location ?? 'Tidak ditentukan'),
                                const SizedBox(height: 10),
                                _DetailRow(icon: Icons.home_outlined, label: 'Alamat Pengiriman', value: 'Jl. Contoh No. 123, Jember'),
                                const SizedBox(height: 10),
                                _DetailRow(
                                  icon: Icons.phone_outlined,
                                  label: 'No. Telepon Penjual',
                                  value: seller?.phone ?? 'Belum ditambahkan',
                                ),
                              ] else ...[
                                _DetailRow(icon: Icons.person_outline, label: 'Nama Pembeli', value: buyer?.name ?? '-'),
                                const SizedBox(height: 10),
                                _DetailRow(icon: Icons.home_outlined, label: 'Alamat Tujuan', value: 'Jl. Pembeli No. 456, Jember'),
                                const SizedBox(height: 10),
                                _DetailRow(
                                  icon: Icons.phone_outlined,
                                  label: 'No. Telepon Pembeli',
                                  value: buyer?.phone ?? 'Belum ditambahkan',
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Ringkasan Pembayaran ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ringkasan Pembayaran',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 12),
                              _PayRow(label: 'Harga Produk (x${widget.order.qty})', value: _formatRupiah(widget.order.price * widget.order.qty)),
                              const SizedBox(height: 6),
                              _PayRow(label: 'Biaya Pengiriman', value: 'Rp10.000'),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(color: _surface),
                              ),
                              _PayRow(label: 'Total', value: _formatRupiah((widget.order.price * widget.order.qty) + 10000), isBold: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (isPembelian && _currentStatus == 'Pending')
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _cancelOrder,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Batalkan Pesanan',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
                          ),

                        if (isPembelian && _currentStatus == 'Dikirim')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _showKonfirmasiTerima,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2e7d32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Pesanan Diterima',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
                          ),

                        if (!isPembelian && _currentStatus == 'Pending')
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _showKonfirmasiPesanan,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Konfirmasi Pesanan',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: _cancelOrder,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Batalkan Pesanan',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                ),
                              ),
                            ],
                          ),

                        if (!isPembelian && _currentStatus == 'Diproses')
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _showKonfirmasiKirim,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Kirim Barang',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: _cancelOrder,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Batalkan Pesanan',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(int index) {
    switch (index) {
      case 0: return Icons.access_time;
      case 1: return Icons.inventory_2_outlined;
      case 2: return Icons.local_shipping_outlined;
      case 3: return Icons.check;
      default: return Icons.circle;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: _primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: _textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({required this.label, required this.value, this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: isBold ? _textPrimary : _textSecondary,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                color: isBold ? _primary : _textPrimary,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}