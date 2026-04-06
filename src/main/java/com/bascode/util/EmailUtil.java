package com.bascode.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    // Send OTP verification email
    public static void sendVerificationEmail(String to, String otp) throws MessagingException {
        final String username = "chisomwork17@gmail.com"; // full Gmail address
        final String password = "jyfsxbpbqkyfofhi";       // 16-char App Password

        String subject = "Your OTP Code";
        String content = "Your OTP code for email verification is: " + otp +
                "\n\nEnter this code on the verification page to activate your account.";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
    }

    // Send password reset email
    public static void sendPasswordResetEmail(String to, String resetLink) throws MessagingException {
        final String username = "chisomwork17@gmail.com"; // full Gmail address
        final String password = "jyfsxbpbqkyfofhi";       // 16-char App Password

        String subject = "Password Reset Link";
        String content = "You requested a password reset.\n\n" +
                "Reset your password using this link:\n" + resetLink + "\n\n" +
                "If you did not request this, you can ignore this email.";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
    }

    public static void sendPasswordResetEmail1(String to, String resetLink) throws MessagingException {
        String host = "smtp.gmail.com";
        String from = "chisomwork17@email.com";
        final String username = "chisomwork17";
        final String password = "jyfsxbpbqkyfofhi";

        String subject = "Password Reset Request";
        String content = "We received a request to reset your password.\n\n"
                + "Use the link below to set a new password:\n"
                + resetLink + "\n\n"
                + "If you didn't request this, you can ignore this email.";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
    }
}
