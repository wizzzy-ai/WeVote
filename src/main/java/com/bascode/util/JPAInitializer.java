package com.bascode.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;


public class JPAInitializer implements ServletContextListener {
    private static EntityManagerFactory emf;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            String puName = envOrDefault("PU_NAME", "VotingPU");
            Map<String, Object> overrideProps = buildJpaOverrideProperties();
            emf = Persistence.createEntityManagerFactory(puName, overrideProps);
            migrateAdminAuditActionType();
            sce.getServletContext().setAttribute("emf", emf);
        } catch (Throwable t) {
            // Log the error and avoid throwing so the webapp still starts
            System.err.println("Failed to initialize EntityManagerFactory: " + t.getMessage());
            t.printStackTrace();
            sce.getServletContext().setAttribute("emf", null);
            // Also store the error message for diagnostics
            sce.getServletContext().setAttribute("emfError", t.toString());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (emf != null && emf.isOpen()) {
            emf.close(); 
        }
    }

    private static void migrateAdminAuditActionType() {
        if (emf == null || !emf.isOpen()) return;

        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.createNativeQuery(
                    "ALTER TABLE admin_audit_logs " +
                    "MODIFY COLUMN actionType VARCHAR(64) NOT NULL"
            ).executeUpdate();
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Admin audit log migration skipped: " + ex.getMessage());
        } finally {
            em.close();
        }
    }

    private static String envOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? fallback : value;
    }

    private static Map<String, Object> buildJpaOverrideProperties() {
        Map<String, Object> props = new HashMap<>();

        String rawUrl = firstNonBlank(
                System.getenv("JDBC_DATABASE_URL"),
                System.getenv("DATABASE_URL"),
                System.getenv("DB_URL")
        );

        DbConfig dbConfig = DbConfig.from(rawUrl);

        String driver = System.getenv("DB_DRIVER");
        if (driver != null && driver.contains("://")) {
            // common misconfig: connection string accidentally placed in DB_DRIVER
            driver = null;
        }

        String jdbcDriver = firstNonBlank(
                driver,
                dbConfig.driver,
                "org.h2.Driver"
        );

        String jdbcUrl = firstNonBlank(
                dbConfig.jdbcUrl,
                "jdbc:h2:mem:votingdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE"
        );

        String username = firstNonBlank(System.getenv("DB_USER"), dbConfig.username, "sa");
        String password = firstNonBlank(System.getenv("DB_PASSWORD"), dbConfig.password, "");

        String hbm2ddl = envOrDefault("HIBERNATE_HBM2DDL_AUTO", "update");

        String dialect = firstNonBlank(
                System.getenv("HIBERNATE_DIALECT"),
                dbConfig.dialect,
                "org.hibernate.dialect.H2Dialect"
        );

        props.put("jakarta.persistence.jdbc.driver", jdbcDriver);
        props.put("jakarta.persistence.jdbc.url", jdbcUrl);
        props.put("jakarta.persistence.jdbc.user", username);
        props.put("jakarta.persistence.jdbc.password", password);

        props.put("hibernate.dialect", dialect);
        props.put("hibernate.hbm2ddl.auto", hbm2ddl);
        props.put("hibernate.show_sql", "false");
        props.put("hibernate.format_sql", "true");

        return props;
    }

    private static String firstNonBlank(String... candidates) {
        if (candidates == null) return null;
        for (String candidate : candidates) {
            if (candidate != null && !candidate.isBlank()) {
                return candidate;
            }
        }
        return null;
    }

    private static final class DbConfig {
        private final String driver;
        private final String jdbcUrl;
        private final String username;
        private final String password;
        private final String dialect;

        private DbConfig(String driver, String jdbcUrl, String username, String password, String dialect) {
            this.driver = driver;
            this.jdbcUrl = jdbcUrl;
            this.username = username;
            this.password = password;
            this.dialect = dialect;
        }

        private static DbConfig from(String rawUrl) {
            if (rawUrl == null || rawUrl.isBlank()) {
                return new DbConfig(null, null, null, null, null);
            }

            String trimmed = rawUrl.trim();
            if (trimmed.startsWith("jdbc:")) {
                return inferFromJdbcUrl(trimmed);
            }

            if (trimmed.startsWith("postgres://") || trimmed.startsWith("postgresql://")) {
                return inferFromPostgresUri(trimmed);
            }

            // Unknown scheme - leave as-is and let Hibernate report a clear error
            return new DbConfig(null, trimmed, null, null, null);
        }

        private static DbConfig inferFromJdbcUrl(String jdbcUrl) {
            if (jdbcUrl.startsWith("jdbc:postgresql:")) {
                return new DbConfig(
                        "org.postgresql.Driver",
                        jdbcUrl,
                        null,
                        null,
                        "org.hibernate.dialect.PostgreSQLDialect"
                );
            }

            if (jdbcUrl.startsWith("jdbc:h2:")) {
                return new DbConfig(
                        "org.h2.Driver",
                        jdbcUrl,
                        null,
                        null,
                        "org.hibernate.dialect.H2Dialect"
                );
            }

            return new DbConfig(null, jdbcUrl, null, null, null);
        }

        private static DbConfig inferFromPostgresUri(String rawUrl) {
            try {
                URI uri = new URI(rawUrl);

                String userInfo = uri.getUserInfo();
                String username = null;
                String password = null;
                if (userInfo != null && !userInfo.isBlank()) {
                    int colonIdx = userInfo.indexOf(':');
                    if (colonIdx >= 0) {
                        username = userInfo.substring(0, colonIdx);
                        password = userInfo.substring(colonIdx + 1);
                    } else {
                        username = userInfo;
                    }
                }

                String host = uri.getHost();
                int port = uri.getPort();
                String path = uri.getPath(); // includes leading '/'
                String query = uri.getQuery();

                if (host == null || host.isBlank() || path == null || path.isBlank()) {
                    return new DbConfig("org.postgresql.Driver", null, username, password, "org.hibernate.dialect.PostgreSQLDialect");
                }

                String portPart = port > 0 ? ":" + port : "";
                String queryPart = query != null && !query.isBlank() ? "?" + query : "";
                String jdbcUrl = "jdbc:postgresql://" + host + portPart + path + queryPart;

                return new DbConfig(
                        "org.postgresql.Driver",
                        jdbcUrl,
                        username,
                        password,
                        "org.hibernate.dialect.PostgreSQLDialect"
                );
            } catch (Exception e) {
                return new DbConfig("org.postgresql.Driver", null, null, null, "org.hibernate.dialect.PostgreSQLDialect");
            }
        }
    }
}
