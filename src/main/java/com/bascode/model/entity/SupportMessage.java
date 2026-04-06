package com.bascode.model.entity;

import com.bascode.model.enums.SupportSender;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "support_messages",
        indexes = {
                @Index(name = "idx_support_msg_conv_time", columnList = "conversation_id, createdAt"),
                @Index(name = "idx_support_msg_admin_unread", columnList = "sender, adminReadAt")
        }
)
public class SupportMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "conversation_id", nullable = false)
    private SupportConversation conversation;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_user_id", nullable = false)
    private User senderUser;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private SupportSender sender;

    @Column(nullable = false, length = 2000)
    private String body;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    // Optional reply reference (message id in the same conversation).
    private Long replyToMessageId;

    // Used for admin unread indicator (set when admin opens the thread).
    private LocalDateTime adminReadAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public SupportConversation getConversation() {
        return conversation;
    }

    public void setConversation(SupportConversation conversation) {
        this.conversation = conversation;
    }

    public User getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(User senderUser) {
        this.senderUser = senderUser;
    }

    public SupportSender getSender() {
        return sender;
    }

    public void setSender(SupportSender sender) {
        this.sender = sender;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Long getReplyToMessageId() {
        return replyToMessageId;
    }

    public void setReplyToMessageId(Long replyToMessageId) {
        this.replyToMessageId = replyToMessageId;
    }

    public LocalDateTime getAdminReadAt() {
        return adminReadAt;
    }

    public void setAdminReadAt(LocalDateTime adminReadAt) {
        this.adminReadAt = adminReadAt;
    }
}
