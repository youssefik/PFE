package com.example.spring_ad_auth.config;

import com.example.spring_ad_auth.repository.RisqueRepository;
import com.example.spring_ad_auth.service.RiskTableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

/*@Component
public class RiskDataInitializer implements CommandLineRunner {

    @Autowired private RiskTableService riskTableService;
    @Autowired
    private RisqueRepository risqueRepo;

    @Override
    public void run(String... args) throws Exception {

*//*        if (risqueRepo.count() == 0) {
            // On lit l'Excel tel qu'il est
            List<List<String>> data = riskTableService.getRiskTableData();
            // On le repasse dans le save pour que le Java fasse les maths (Max, multiplications)
            riskTableService.saveRiskTable(data);
        }*//*

    }
}*/
