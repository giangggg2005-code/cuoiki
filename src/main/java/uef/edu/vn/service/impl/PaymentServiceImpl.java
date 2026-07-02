package uef.edu.vn.service.impl;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import uef.edu.vn.exception.PaymentException;
import uef.edu.vn.model.Payment;
import uef.edu.vn.repository.PaymentRepository;
import uef.edu.vn.service.PaymentService;

@Service
public class PaymentServiceImpl implements PaymentService {

    private static final long QR_EXPIRY_MS = 15 * 60 * 1000L;

    private final PaymentRepository paymentRepo;
    private final Map<Integer, PendingQrPayment> pendingQrPayments = new ConcurrentHashMap<>();

    @Autowired
    public PaymentServiceImpl(PaymentRepository paymentRepo) {
        this.paymentRepo = paymentRepo;
    }

    private static final class PendingQrPayment {
        private final String transactionCode;
        private final double amount;
        private final long createdAt;

        private PendingQrPayment(String transactionCode, double amount, long createdAt) {
            this.transactionCode = transactionCode;
            this.amount = amount;
            this.createdAt = createdAt;
        }
    }

    @Override
    public List<Payment> getPaymentsByUser(int userId) {
        if (userId <= 0) {
            throw new PaymentException("Mã người dùng không hợp lệ!");
        }
        return paymentRepo.getPaymentsByUser(userId);
    }

    @Override
    public Payment getPaymentById(int paymentId) {
        Payment payment = paymentRepo.findById(paymentId);
        if (payment == null) {
            throw new PaymentException("Không tìm thấy thẻ thanh toán!");
        }
        return payment;
    }

    @Override
    public boolean verifyPin(int paymentId, String pin) {
        if (pin == null || pin.isEmpty()) {
            throw new PaymentException("Vui lòng nhập mã PIN!");
        }
        Payment payment = getPaymentById(paymentId);
        return payment.getPinCode() != null && payment.getPinCode().equals(pin);
    }

    @Override
    @Transactional
    public boolean processCardPayment(int paymentId, int userId, String pin, double amount) {
        validatePaymentAmount(amount);
        Payment payment = getPaymentById(paymentId);
        executeCardPayment(payment, pin, amount);
        return true;
    }

    @Override
    public void verifyCardPin(String cardNumber, String pin) {
        Payment payment = resolveCardForPayment(cardNumber);
        verifyPinMatches(payment, pin);
    }

    @Override
    @Transactional
    public int processCardPaymentByCardNumber(String cardNumber, int userId, String pin, double amount) {
        validatePaymentAmount(amount);
        Payment payment = resolveCardForPayment(cardNumber);
        executeCardPayment(payment, pin, amount);
        return payment.getId_Payment();
    }

    private Payment resolveCardForPayment(String cardNumber) {
        if (cardNumber == null || cardNumber.isEmpty()) {
            throw new PaymentException("Vui lòng nhập số thẻ thanh toán!");
        }
        if (!cardNumber.matches("^9704-0000-1111-\\d{4}$")) {
            throw new PaymentException(
                    "Số thẻ thanh toán không hợp lệ! Vui lòng nhập chính xác theo định dạng: 9704-0000-1111-0001");
        }
        Payment payment = paymentRepo.findByCardNumber(cardNumber);
        if (payment == null) {
            throw new PaymentException("Số thẻ thanh toán không tồn tại hoặc không chính xác!");
        }
        return payment;
    }

    private void verifyPinMatches(Payment payment, String pin) {
        if (pin == null || pin.isEmpty()) {
            throw new PaymentException("Vui lòng nhập mã PIN!");
        }
        String storedPin = payment.getPinCode();
        if (storedPin == null || storedPin.isEmpty()) {
            throw new PaymentException("Thẻ thanh toán chưa được cấu hình mã PIN trong hệ thống!");
        }
        if (!storedPin.equals(pin)) {
            throw new PaymentException("Mã PIN không chính xác! Vui lòng nhập đúng mã PIN của thẻ.");
        }
    }

    private void validatePaymentAmount(double amount) {
        if (amount <= 0) {
            throw new PaymentException("Số tiền thanh toán không hợp lệ!");
        }
    }

    private void executeCardPayment(Payment payment, String pin, double amount) {
        verifyPinMatches(payment, pin);

        if (amount > payment.getBalance()) {
            throw new PaymentException(
                    "Số tiền thanh toán (" + formatVnd(amount) + "đ) lớn hơn số dư còn lại trong thẻ ("
                            + formatVnd(payment.getBalance()) + "đ)!");
        }
        if (!paymentRepo.deductBalance(payment.getId_Payment(), amount)) {
            throw new PaymentException("Thanh toán thất bại! Vui lòng thử lại.");
        }
    }

    private String formatVnd(double amount) {
        return String.format("%,.0f", amount).replace(',', '.');
    }

    @Override
    @Transactional
    public boolean refundCardPayment(int paymentId, int userId, double amount) {
        if (amount <= 0) {
            throw new PaymentException("Số tiền hoàn không hợp lệ!");
        }

        Payment payment = getPaymentById(paymentId);
        if (payment.getUserId() != userId) {
            throw new PaymentException("Thẻ thanh toán không thuộc về tài khoản của bạn!");
        }
        if (!paymentRepo.refundBalance(paymentId, amount)) {
            throw new PaymentException("Hoàn tiền thất bại!");
        }
        return true;
    }

    @Override
    public String generateQrTransactionCode(int userId, double amount) {
        if (userId <= 0 || amount <= 0) {
            throw new PaymentException("Không thể tạo mã QR thanh toán!");
        }
        String code = "UEFCINEMA|" + userId + "|" + (long) amount + "|"
                + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        pendingQrPayments.put(userId, new PendingQrPayment(code, amount, System.currentTimeMillis()));
        return code;
    }

    @Override
    public boolean verifyAndConsumeQrPayment(int userId, String transactionCode, double amount) {
        if (transactionCode == null || transactionCode.trim().isEmpty()) {
            throw new PaymentException("Vui lòng quét mã QR và xác nhận thanh toán trước khi đặt vé!");
        }

        PendingQrPayment pending = pendingQrPayments.get(userId);
        if (pending == null) {
            throw new PaymentException("Chưa có mã QR thanh toán hợp lệ. Vui lòng tạo lại mã QR!");
        }
        if (System.currentTimeMillis() - pending.createdAt > QR_EXPIRY_MS) {
            pendingQrPayments.remove(userId);
            throw new PaymentException("Mã QR đã hết hạn. Vui lòng tạo lại mã QR!");
        }
        if (!pending.transactionCode.equals(transactionCode.trim())) {
            throw new PaymentException("Mã giao dịch QR không hợp lệ!");
        }
        if (Math.abs(pending.amount - amount) > 0.01) {
            throw new PaymentException("Số tiền thanh toán QR không khớp với đơn đặt vé!");
        }

        pendingQrPayments.remove(userId);
        return true;
    }
}
