package com.bascode.config;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JPAInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Decide which persistence unit to use
        String puName = System.getenv().getOrDefault("PU_NAME", "VotingPU");

        EntityManagerFactory emf = Persistence.createEntityManagerFactory(puName);
        sce.getServletContext().setAttribute("emf", emf);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        EntityManagerFactory emf = (EntityManagerFactory) sce.getServletContext().getAttribute("emf");
        if (emf != null) {
            emf.close();
        }
    }
}