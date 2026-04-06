package com.bascode.model.entity;

import com.bascode.model.enums.ElectionStatus;
import com.bascode.model.enums.Position;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "position_elections",
        uniqueConstraints = @UniqueConstraint(columnNames = "name")
)
public class PositionElection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40, unique = true)
    private Position name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ElectionStatus status = ElectionStatus.NOT_STARTED;

    @Column(nullable = false)
    private boolean votingOpen = false;

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    public Long getId() {
        return id;
    }

    public Position getName() {
        return name;
    }

    public void setName(Position name) {
        this.name = name;
    }

    public ElectionStatus getStatus() {
        return status;
    }

    public void setStatus(ElectionStatus status) {
        this.status = status;
    }

    public boolean isVotingOpen() {
        return votingOpen;
    }

    public void setVotingOpen(boolean votingOpen) {
        this.votingOpen = votingOpen;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }
}

