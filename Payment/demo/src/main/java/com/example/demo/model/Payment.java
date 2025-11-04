package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "payments")
public class Payment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, name = "order_id")
    private Long orderId;
    
    @Column(nullable = false)
    private Double amount;
    
    @Column(nullable = false, name = "payment_mode")
    private String paymentMode; // CREDIT_CARD, DEBIT_CARD, UPI, NET_BANKING, CASH
    
    @Column(nullable = false, name = "payment_status")
    private String paymentStatus; // PENDING, SUCCESS, FAILED, REFUNDED
    
    // Constructors
    public Payment() {
    }
    
    public Payment(Long orderId, Double amount, String paymentMode, String paymentStatus) {
        this.orderId = orderId;
        this.amount = amount;
        this.paymentMode = paymentMode;
        this.paymentStatus = paymentStatus;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public Double getAmount() {
        return amount;
    }
    
    public void setAmount(Double amount) {
        this.amount = amount;
    }
    
    public String getPaymentMode() {
        return paymentMode;
    }
    
    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
