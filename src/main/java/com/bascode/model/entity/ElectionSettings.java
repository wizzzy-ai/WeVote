package com.bascode.model.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "election_settings")
public class ElectionSettings {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private boolean votingOpen = true;

    // Optional. If set and current time is after it, voting is considered closed.
    private LocalDateTime votingClosesAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "updated_by_user_id")
    private User updatedBy;

    @PrePersist
    @PreUpdate
    void touch() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public boolean isVotingOpen() {
        return votingOpen;
    }

    public void setVotingOpen(boolean votingOpen) {
        this.votingOpen = votingOpen;
    }

    public LocalDateTime getVotingClosesAt() {
        return votingClosesAt;
    }

    public void setVotingClosesAt(LocalDateTime votingClosesAt) {
        this.votingClosesAt = votingClosesAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public User getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(User updatedBy) {
        this.updatedBy = updatedBy;
    }
}

