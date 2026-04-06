package com.bascode.model.entity;

import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "contesters")
public class Contester {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private User user;

    @Enumerated(EnumType.STRING)
    private Position position;

    @Enumerated(EnumType.STRING)
    private ContesterStatus status;

    private LocalDateTime createdAt;
    private LocalDateTime statusUpdatedAt;

    @Column(length = 500)
    private String statusReason;

    @Column(nullable = false)
    private boolean winner = false;

    @Column(length = 2000)
    private String manifesto;

    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Position getPosition() {
		return position;
	}

	public void setPosition(Position position) {
		this.position = position;
	}

    public ContesterStatus getStatus() {
        return status;
    }

    public void setStatus(ContesterStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getStatusUpdatedAt() {
        return statusUpdatedAt;
    }

    public String getStatusReason() {
        return statusReason;
    }

    public void setStatusReason(String statusReason) {
        this.statusReason = statusReason;
    }

    public boolean isWinner() {
        return winner;
    }

    public void setWinner(boolean winner) {
        this.winner = winner;
    }

    public String getManifesto() {
        return manifesto;
    }

    public void setManifesto(String manifesto) {
        this.manifesto = manifesto;
    }

    @PrePersist
    void onCreate() {
        createdAt = LocalDateTime.now();
        if (statusUpdatedAt == null) {
            statusUpdatedAt = createdAt;
        }
    }

    @PreUpdate
    void onUpdate() {
        statusUpdatedAt = LocalDateTime.now();
    }
    
    
}
