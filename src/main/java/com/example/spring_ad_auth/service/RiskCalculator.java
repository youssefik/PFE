package com.example.spring_ad_auth.service;

import org.springframework.stereotype.Component;

@Component
public class RiskCalculator {
    public int calculateScore(int value, int proba, int gravite) {
        return value * proba * gravite;
    }
}

/*
@Component
public class RiskCalculator {

    public int calculateInitialScore(int c, int i, int d, int proba, int gravite) {
        int maxCID = Math.max(c, Math.max(i, d));
        return maxCID * proba * gravite;
    }

    public int calculateResidualScore(int initialScore, int efficiencyPercentage) {
        double reduction = (double) efficiencyPercentage / 100.0;
        return (int) (initialScore * (1 - reduction));
    }
}*/
