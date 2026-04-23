package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.ExcelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.List;

@Controller
public class ExcelController {
    @Autowired
    private ExcelService excelService;

    @GetMapping("/excel/data")
    @ResponseBody
    public List<List<String>> getExcelData() throws IOException {
        return excelService.readAll();
    }
}
