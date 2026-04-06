package com.bascode.util;

import com.bascode.model.entity.User;
import java.time.LocalDate;
import java.time.Period;

public final class AgeUtil {
    private AgeUtil() {
    }

    public static boolean isUnderage(User user) {
        if (user == null) return false;
        LocalDate today = LocalDate.now();
        LocalDate birthDate = user.getBirthDate();
        if (birthDate != null) {
            return Period.between(birthDate, today).getYears() < 18;
        }
        int birthYear = user.getBirthYear();
        if (birthYear <= 0) return false;
        return (today.getYear() - birthYear) < 18;
    }
}
