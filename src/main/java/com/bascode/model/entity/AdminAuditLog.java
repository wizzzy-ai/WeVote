package com.bascode.model.entity;

import com.bascode.model.enums.AdminActionType;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "admin_audit_logs")
public class AdminAuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "admin_user_id", nullable = false)
    private User adminUser;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AdminActionType actionType;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false, length = 64)
    private String targetType; // e.g. "Contester"

    @Column(nullable = false)
    private Long targetId;

    @Column(length = 512)
    private String message;

    @Column(length = 45)
    private String ipAddress;

    @Column(length = 256)
    private String userAgent;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public User getAdminUser() {
        return adminUser;
    }

    public void setAdminUser(User adminUser) {
        this.adminUser = adminUser;
    }

    public AdminActionType getActionType() {
        return actionType;
    }

    public void setActionType(AdminActionType actionType) {
        this.actionType = actionType;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public Long getTargetId() {
        return targetId;
    }

    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
}

