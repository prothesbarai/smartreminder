import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BkashPaymentPage extends StatefulWidget {
  final double amount;
  final String bkashNumber;

  const BkashPaymentPage({super.key, required this.amount, required this.bkashNumber,});

  @override
  State<BkashPaymentPage> createState() => _BkashPaymentPageState();
}

class _BkashPaymentPageState extends State<BkashPaymentPage> {
  final TextEditingController trxController = TextEditingController();
  bool loading = false;

  void snack(String msg, {Color color = const Color(0xFF111827)}) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating,),);}
  void copyNumber() {Clipboard.setData(ClipboardData(text: widget.bkashNumber));snack("Copied successfully", color: Colors.green);}

  Future<void> submit() async {
    if (trxController.text.trim().isEmpty) {snack("Transaction ID required", color: Colors.red);return;}
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => loading = false);
    if(!mounted) return;
    Navigator.pop(context, {"trx_id": trxController.text.trim(), "status": "pending",});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0F19),

      body: Stack(
        children: [

          // >>> ================= BACKGROUND GLOW =============================
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(color: const Color(0xFFe2136e).withValues(alpha: 0.25), shape: BoxShape.circle,),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(color: Colors.pink.withValues(alpha: 0.15), shape: BoxShape.circle,),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                // >>>> ================= HEADER ===============================
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Secure Payment", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600,),),
                      const SizedBox(height: 6),
                      Text("Pay ৳${widget.amount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70, fontSize: 14,),),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // >>>> ================= GLASS CARD ===========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.08),),),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Payment Instructions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
                            const SizedBox(height: 12),
                            _glassTile(icon: Icons.send, title: "Send Money To", subtitle: widget.bkashNumber, action: Icons.copy, onTap: copyNumber,),
                            const SizedBox(height: 12),
                            _glassTile(icon: Icons.security, title: "Important", subtitle: "Check SMS for Transaction ID",),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // <<<< ================= GLASS CARD ===========================

                const SizedBox(height: 20),

                // >>>>> ================= INPUT ===============================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.08),),),
                        child: TextField(
                          controller: trxController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(hintText: "Enter Transaction ID", hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none,),
                        ),
                      ),
                    ),
                  ),
                ),
                // <<<<< ================= INPUT ===============================

                const Spacer(),

                // >>>>> ================= BOTTOM ACTION =======================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: loading ? null : submit,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFe2136e), Color(0xFFff4d94),],), borderRadius: BorderRadius.circular(14),),
                      child: Center(
                        child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),) :
                        const Text("Confirm Payment", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500,),),
                      ),
                    ),
                  ),
                ),
                // <<<<< ================= BOTTOM ACTION =======================
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// >>>>> Glass Tile Design Here =============================================
  Widget _glassTile({required IconData icon, required String title, required String subtitle, IconData? action, VoidCallback? onTap,}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.06)),),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12,),),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
              ],
            ),
          ),

          if (action != null)...[
            GestureDetector(onTap: onTap, child: Icon(action, color: Colors.white54, size: 18),),
          ],
        ],
      ),
    );
  }
  /// <<<<< Glass Tile Design Here =============================================
}