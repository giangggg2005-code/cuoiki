package uef.edu.vn.service;

import java.util.List;
import uef.edu.vn.model.Payment;

public interface PaymentService {

    List<Payment> getPaymentsByUser(int userId);

    Payment getPaymentById(int paymentId);

    boolean verifyPin(int paymentId, String pin);

    boolean processCardPayment(int paymentId, int userId, String pin, double amount);

    int processCardPaymentByCardNumber(String cardNumber, int userId, String pin, double amount);

    void verifyCardPin(String cardNumber, String pin);

    boolean refundCardPayment(int paymentId, int userId, double amount);

    String generateQrTransactionCode(int userId, double amount);

    boolean verifyAndConsumeQrPayment(int userId, String transactionCode, double amount);
}
