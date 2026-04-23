package com.example.spring_ad_auth.controller;

import com.example.spring_ad_auth.service.RiskSyncService;
import com.example.spring_ad_auth.service.RiskTableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.text.SimpleDateFormat;
import java.util.*;


@Controller
@RequestMapping("/rssi/risk-editor")
public class RiskController {
    @Autowired private RiskTableService riskTableService;



    @GetMapping
    public String viewEditor() {
        return "rssi/risk_editor";
    }

/*    @GetMapping("/data-json")
    @ResponseBody
    public List<Map<String, Object>> getRisks() throws IOException {
        return riskTableService.getJsonRisksFromExcel();
    }*/

    @GetMapping("/data-json")
    @ResponseBody
    public List<Map<String, Object>> getRisks() {
        // On ne lit plus l'Excel ici ! On lit ce qui est en BD
        return riskTableService.getRisksFromDatabase();
    }


    @PostMapping("/save")
    @ResponseBody
    public String saveRisks(@RequestBody List<Map<String, Object>> risks) {
        try {
            System.out.println("📥 Sauvegarde reçue, nombre d'éléments : " + risks.size());
            riskTableService.saveAllRisks(risks);
            System.out.println("✅ Sauvegarde réussie");
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }


    @GetMapping("/sync-to-excel")
    @ResponseBody
    public String manualSync() {
        try {
            riskTableService.syncDatabaseToExcel();
            return "SUCCESS : Le fichier Excel a été synchronisé avec la base de données.";
        } catch (Exception e) {
            return "ERROR : " + e.getMessage();
        }
    }


    @GetMapping("/history")
    @ResponseBody
    public List<Map<String, String>> getVersionHistory() {
        String historyDir = "D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/";
        File folder = new File(historyDir);
        List<Map<String, String>> fileList = new ArrayList<>();

        if (folder.exists() && folder.isDirectory()) {
            File[] files = folder.listFiles((dir, name) -> name.endsWith(".xlsx"));
            if (files != null) {
                Arrays.sort(files, Comparator.comparingLong(File::lastModified).reversed());
                for (File f : files) {
                    Map<String, String> fileInfo = new HashMap<>();
                    fileInfo.put("name", f.getName()); // "name" en minuscules
                    fileInfo.put("date", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(f.lastModified())); // "date" en minuscules
                    fileList.add(fileInfo);
                }
            }
        }
        return fileList;
    }

/*    @GetMapping("/history")
    @ResponseBody
    public List<Map<String, String>> getVersionHistory() {
        String historyDir = "D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/";
        File folder = new File(historyDir);
        List<Map<String, String>> fileList = new ArrayList<>();

        if (folder.exists() && folder.isDirectory()) {
            File[] files = folder.listFiles((dir, name) -> name.endsWith(".xlsx"));

            if (files != null) {
                // Trier les fichiers par date de modification (décroissant)
                Arrays.sort(files, Comparator.comparingLong(File::lastModified).reversed());

                for (File f : files) {
                    Map<String, String> fileInfo = new HashMap<>();
                    fileInfo.put("name", f.getName());
                    // On peut même ajouter la date lisible pour le front-end
                    fileInfo.put("date", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(f.lastModified()));
                    fileList.add(fileInfo);
                }
            }
        }
        return fileList;
    }*/
//    @GetMapping("/history")
//    @ResponseBody
//    public List<String> getVersionHistory() {
//        File folder = new File("D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/");
//        if (!folder.exists()) return new ArrayList<>();
//
//        return Arrays.stream(folder.listFiles())
//                .map(File::getName)
//                .sorted(Comparator.reverseOrder()) // Les plus récents en premier
//                .toList();
//    }


//    @GetMapping("/download-version")
//    public ResponseEntity<Resource> downloadFile(@RequestParam String name) {
//        try {
//            String path = "D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/" + name;
//            File file = new File(path);
//            Path filePath = file.toPath();
//            Resource resource = new UrlResource(filePath.toUri());
//
//            return ResponseEntity.ok()
//                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getName() + "\"")
//                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
//                    .body(resource);
//        } catch (Exception e) {
//            return ResponseEntity.notFound().build();
//        }
//    }


    @GetMapping("/download-version")
    public ResponseEntity<Resource> downloadFile(@RequestParam String name) {
        try {
            // Chemin absolu vers ton dossier history
            String historyDir = "D:/Downoalds/spring-ad-auth/spring-ad-auth/history/risks/";
            File file = new File(historyDir + name);

            if (!file.exists()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            // Construction sécurisée du header pour préserver l'extension
            ContentDisposition contentDisposition = ContentDisposition.builder("attachment")
                    .filename(file.getName())
                    .build();

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition.toString())
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(resource);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}

/*@Controller
@RequestMapping("/rssi/risk-editor")
public class RiskController {

    @Autowired private RiskTableService riskTableService;


    @GetMapping
    public String viewEditor() {
        return "rssi/risk_editor";
    }


    @GetMapping("/data-json")
    @ResponseBody
    public List<Map<String, Object>> getCleanData() throws IOException {
        // Cette méthode renvoie exactement ce que votre script Python produisait
        return riskTableService.getJsonRisksFromExcel();
    }*/

/*    @GetMapping("/data")
    @ResponseBody
    public List<List<String>> getData() throws IOException {
        return riskTableService.getRiskTableData();
    }

    @PostMapping("/save")
    @ResponseBody
    public String save(@RequestBody List<List<String>> data) {
        try {
            riskTableService.saveRiskTable(data);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }*/
/*
}
*/

/*@Controller
@RequestMapping("/rssi/risk-editor")*/
/*
public class RiskController {

    @Autowired private RiskTableService riskTableService;

    @GetMapping
    public String viewEditor() {
        return "rssi/risk_editor";
    }

    @GetMapping("/data")
    @ResponseBody
    public List<List<String>> getData() throws IOException {
        // Appel de votre service qui lit l'Excel et injecte les données
        return riskTableService.getRiskTableData();
    }

    @PostMapping("/save")
    @ResponseBody
    public String save(@RequestBody List<List<String>> data) {
        try {
            riskTableService.saveRiskTable(data);
            return "SUCCESS";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}*/
