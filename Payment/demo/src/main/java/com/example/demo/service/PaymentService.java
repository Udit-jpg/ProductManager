package com.example.demo.service;

import com.example.demo.model.Payment;
import com.example.demo.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {
    
    @Autowired
    private PaymentRepository paymentRepository;
    
    // Create payment
    public Payment createPayment(Payment payment) {
        // Set default status if not provided
        if (payment.getPaymentStatus() == null || payment.getPaymentStatus().isEmpty()) {
            payment.setPaymentStatus("PENDING");
        }
        return paymentRepository.save(payment);
    }
    
    // Get all payments
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }
    
    // Get payment by ID
    public Optional<Payment> getPaymentById(Long id) {
        return paymentRepository.findById(id);
    }
    
    // Get payment by order ID
    public Optional<Payment> getPaymentByOrderId(Long orderId) {
        return paymentRepository.findByOrderId(orderId);
    }
    
    // Get payments by status
    public List<Payment> getPaymentsByStatus(String status) {
        return paymentRepository.findByPaymentStatus(status);
    }
    
    // Get payments by payment mode
    public List<Payment> getPaymentsByMode(String mode) {
        return paymentRepository.findByPaymentMode(mode);
    }
    
    // Update payment
    public Payment updatePayment(Long id, Payment paymentDetails) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        
        payment.setOrderId(paymentDetails.getOrderId());
        payment.setAmount(paymentDetails.getAmount());
        payment.setPaymentMode(paymentDetails.getPaymentMode());
        payment.setPaymentStatus(paymentDetails.getPaymentStatus());
        
        return paymentRepository.save(payment);
    }
    
    // Update payment status
    public Payment updatePaymentStatus(Long id, String status) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        
        payment.setPaymentStatus(status);
        return paymentRepository.save(payment);
    }
    
    // Process payment (simulate payment processing)
    public Payment processPayment(Long id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        
        // Simulate payment processing logic
        // In real scenario, this would integrate with payment gateway
        payment.setPaymentStatus("SUCCESS");
        return paymentRepository.save(payment);
    }
    
    // Delete payment
    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }
}
