package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.mapper.ImprovementMapper;
import com.example.spring_ad_auth.model.ActionAmelioration;
import com.example.spring_ad_auth.model.ActionCorrective;
import com.example.spring_ad_auth.repository.ImprovementRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;


@Service
public class ImprovementService {
    @Autowired private ImprovementRepository repo;
    @Autowired private ImprovementMapper mapper;
    @Autowired private ExcelService excelService;

    private static final String FILE_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/Journal_Amelioration.xlsx";


    @Transactional
    public void initJournalFromExcel() throws IOException {
        // Lecture de 12 colonnes, Sheet 1, à partir de l'index 7 (ligne 8 Excel)
        List<List<String>> data = excelService.readGenericFromLine(FILE_PATH, 12, 1, 7);

        List<ActionAmelioration> entities = new ArrayList<>();
        ActionAmelioration currentAction = null;

        for (List<String> row : data) {
            if (row.isEmpty() || row.stream().allMatch(String::isEmpty)) continue;

            String numero = getSafe(row, 0); // Col A
            String actionTxt = getSafe(row, 1); // Col B
            String dateBesoin = getSafe(row, 4); // Col E
            String analyse = getSafe(row, 8); // Col I

            // CONDITION 1 : C'est le début d'une NOUVELLE ACTION (Numéro présent)
            if (!numero.isEmpty()) {
                currentAction = mapper.mapToEntity(row, numero, dateBesoin);

                // Gestion du statut par défaut "EN_COURS"
                if (currentAction.getStatut() == null || currentAction.getStatut().isEmpty()) {
                    currentAction.setStatut("EN_COURS");
                }

                entities.add(currentAction);
            }

            // CONDITION 2 : C'est une ligne de CONTINUATION (Numéro vide mais Date ou Analyse présente)
            else if (currentAction != null) {
                // On ajoute la date supplémentaire avec un retour à la ligne
                if (!dateBesoin.isEmpty()) {
                    String existingDates = currentAction.getDateBesoin();
                    currentAction.setDateBesoin(existingDates + "\n" + dateBesoin);
                }

                // On ajoute l'analyse de cause supplémentaire
                if (!analyse.isEmpty()) {
                    String existingAnalyse = currentAction.getAnalyseCause();
                    currentAction.setAnalyseCause(existingAnalyse + "\n" + analyse);
                }
            }
        }

        repo.deleteAll();
        repo.saveAll(entities);
        System.out.println("✅ Importation réussie : " + entities.size() + " actions consolidées.");
    }


    private String getSafe(List<String> row, int i) {
        return (i < row.size() && row.get(i) != null) ? row.get(i).trim() : "";
    }

    @Transactional
    public void saveAll(List<Map<String, Object>> data) throws IOException {
        List<ActionAmelioration> dbList = new ArrayList<>();
        List<List<String>> excelGrid = new ArrayList<>();

        for (Map<String, Object> m : data) {
            // Création d'une ligne de 12 colonnes pour Excel
            String[] rowArr = new String[12];
            Arrays.fill(rowArr, "");

            rowArr[0] = String.valueOf(m.getOrDefault("numero", ""));
            rowArr[1] = String.valueOf(m.getOrDefault("action", ""));
            rowArr[4] = String.valueOf(m.getOrDefault("dateBesoin", ""));
            rowArr[6] = String.valueOf(m.getOrDefault("responsable", ""));
            rowArr[8] = String.valueOf(m.getOrDefault("analyseCause", ""));
            rowArr[9] = String.valueOf(m.getOrDefault("statut", ""));
            rowArr[10] = String.valueOf(m.getOrDefault("dateCloture", ""));
            rowArr[11] = String.valueOf(m.getOrDefault("efficacite", ""));

            List<String> rowList = Arrays.asList(rowArr);
            excelGrid.add(rowList);
            dbList.add(mapper.mapToEntity(rowList, "", ""));
        }

        repo.deleteAll();
        repo.saveAll(dbList);
        // Sync vers Excel : Sheet 1, à partir de la ligne 8 (index 7)
        excelService.saveToExcel(FILE_PATH, excelGrid, 12, 1, 7);
    }


    // Dans ImprovementService.java

    @Transactional
    public void addActionFromAudit(ActionCorrective action) {
        // 1. Calcul du nouveau numéro (ex: #009)
        long count = repo.count() + 1;
        String nextNum = "#" + String.format("%03d", count);

        // 2. Création de l'entrée dans le Journal
        ActionAmelioration journalEntry = new ActionAmelioration();
        journalEntry.setNumero(nextNum);

        // Le texte de l'action corrective
        journalEntry.setActionCorrective(action.getTitre());

        // Date d'enregistrement (aujourd'hui)
        journalEntry.setDateBesoin(LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

        journalEntry.setResponsable(action.getResponsable());

        // On récupère le constat pour expliquer la cause
        if (action.getNonConformite() != null && action.getNonConformite().getConstat() != null) {
            journalEntry.setAnalyseCause("Constat d'audit : " + action.getNonConformite().getConstat().getDescription());
        }

        journalEntry.setStatut("EN_COURS"); // Par défaut

        // 3. Sauvegarde en Base de Données
        repo.save(journalEntry);

        // 4. Synchronisation immédiate vers Excel
        try {
            // On récupère tout le journal pour mettre à jour l'Excel au complet (Index 1, Ligne 8)
            List<Map<String, Object>> currentJournal = repo.findAll().stream()
                    .map(mapper::mapToMap)
                    .toList();

            // On réutilise votre méthode saveToExcel configurée pour l'index 1 (feuille 2) et ligne 8
            this.saveAll(currentJournal);
            System.out.println("✅ Journal Excel synchronisé avec la nouvelle action d'audit.");
        } catch (IOException e) {
            System.err.println("⚠️ Erreur lors de la mise à jour Excel : " + e.getMessage());
        }
    }
}

/*@Service
public class ImprovementService {
    @Autowired private ExcelService excelService;
    @Autowired private ImprovementRepository repo;
    @Autowired private ImprovementMapper mapper;

    private static final String FILE_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/Journal_Amelioration.xlsx";

    @Transactional
    public void initJournalFromExcel() throws IOException {
        // Lecture Index 1 (Feuille 2), début ligne 8 (index 7)
        List<List<String>> data = excelService.readGenericFromLine(FILE_PATH, 8, 1, 7);

        String lastDate = "";
        List<ActionAmelioration> entities = new ArrayList<>();

        for (List<String> row : data) {
            // Ignorer si toute la ligne est vide
            if (row.stream().allMatch(String::isEmpty)) continue;

            // Mise à jour de la mémoire si une nouvelle date est présente en colonne C (index 2)
            String dateInRow = (row.size() > 2) ? row.get(2).trim() : "";
            if (!dateInRow.isEmpty()) {
                lastDate = dateInRow;
            }

            // Création de l'entité avec support de la date héritée
            entities.add(mapper.mapToEntity(row, lastDate));
        }

        repo.deleteAll(); // On repart sur une base propre
        repo.saveAll(entities);
        System.out.println("✅ Importation réussie : " + entities.size() + " actions enregistrées.");
    }

    @Transactional
    public void saveAll(List<Map<String, Object>> data) throws IOException {
        List<ActionAmelioration> entities = new ArrayList<>();
        List<List<String>> excelList = new ArrayList<>();

        for (Map<String, Object> m : data) {
            // Mapping inverse pour la BD
            ActionAmelioration a = new ActionAmelioration();
            a.setNumero(val(m, "numero"));
            a.setActionCorrective(val(m, "action"));
            a.setDateBesoin(val(m, "dateBesoin"));
            a.setResponsable(val(m, "responsable"));
            a.setAnalyseCause(val(m, "analyseCause"));
            a.setStatut(val(m, "statut"));
            a.setDateCloture(val(m, "dateCloture"));
            a.setEfficacite(val(m, "efficacite"));
            entities.add(a);

            // Structure pour Excel (Doit respecter A à H)
            excelList.add(Arrays.asList(
                    a.getNumero(), a.getActionCorrective(), a.getDateBesoin(),
                    a.getResponsable(), a.getAnalyseCause(), a.getStatut(),
                    a.getDateCloture(), a.getEfficacite()
            ));
        }

        repo.deleteAll();
        repo.saveAll(entities);

        // Sauvegarde physique dans Excel à partir de la ligne 8 (index 7)
        excelService.saveToExcel(FILE_PATH, excelList, 8, 1, 7);
    }

    private String val(Map<String, Object> m, String key) {
        return m.get(key) != null ? String.valueOf(m.get(key)).trim() : "";
    }
}*/

/*@Service
public class ImprovementService {

    @Autowired private ExcelService excelService;
    @Autowired private ImprovementRepository repo;
    @Autowired private ImprovementMapper mapper;

    private static final String FILE_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/Journal_Amelioration.xlsx";

    // INITIALISATION : Lit l'index 1 à partir de la ligne 8 (index 7)
    public void initJournalFromExcel() throws IOException {
        // Paramètres : (Chemin, NbColonnes=8, IndexFeuille=1, LigneDebut=7)
        List<List<String>> data = excelService.readGenericFromLine(FILE_PATH, 8, 1, 7);

        if (data == null || data.isEmpty()) return;

        List<ActionAmelioration> entities = new ArrayList<>();
        for (List<String> row : data) {
            // Sécurité : ignorer si les deux premières colonnes sont vides
            if (row.size() < 2 || (row.get(0).isEmpty() && row.get(1).isEmpty())) continue;
            entities.add(mapper.mapToEntity(row));
        }

        repo.saveAll(entities);
        System.out.println("✅ Importation réussie depuis la feuille Index 1 : " + entities.size() + " lignes.");
    }

    // SAUVEGARDE : Écrit sur l'index 1 à partir de la ligne 8 (index 7)
    @Transactional
    public void saveAll(List<Map<String, Object>> data) throws IOException {
        List<ActionAmelioration> entities = new ArrayList<>();
        List<List<String>> listForExcel = new ArrayList<>();

        for (Map<String, Object> m : data) {
            ActionAmelioration a = new ActionAmelioration();
            a.setNumero(String.valueOf(m.getOrDefault("numero", "")));
            a.setActionCorrective(String.valueOf(m.getOrDefault("action", "")));
            a.setDateBesoin(String.valueOf(m.getOrDefault("dateBesoin", "")));
            a.setResponsable(String.valueOf(m.getOrDefault("responsable", "")));
            a.setAnalyseCause(String.valueOf(m.getOrDefault("analyseCause", "")));
            a.setStatut(String.valueOf(m.getOrDefault("statut", "")));
            a.setDateCloture(String.valueOf(m.getOrDefault("dateCloture", "")));
            a.setEfficacite(String.valueOf(m.getOrDefault("efficacite", "")));
            entities.add(a);

            // Préparation des données pour la ligne Excel
            List<String> row = new ArrayList<>();
            row.add(a.getNumero());
            row.add(a.getActionCorrective());
            row.add(a.getDateBesoin());
            row.add(a.getResponsable());
            row.add(a.getAnalyseCause());
            row.add(a.getStatut());
            row.add(a.getDateCloture());
            row.add(a.getEfficacite());
            listForExcel.add(row);
        }

        repo.deleteAll();
        repo.saveAll(entities);

        // SYNC EXCEL sur l'index 1
        excelService.saveToExcel(FILE_PATH, listForExcel, 8, 1, 7);
    }
}*/


/*
@Service
public class ImprovementService {

    @Autowired
    private ExcelService excelService;

    @Autowired
    private ImprovementRepository repo; // Utilisation de ton nom réel

    @Autowired
    private ImprovementMapper mapper;

    private static final String FILE_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/Journal_Amelioration.xlsx";

    @Transactional
    public void saveAll(List<Map<String, Object>> data) throws IOException {
        List<ActionAmelioration> entities = new ArrayList<>();
        List<List<String>> listForExcel = new ArrayList<>();

        for (Map<String, Object> m : data) {
            ActionAmelioration a = new ActionAmelioration();
            a.setNumero(String.valueOf(m.getOrDefault("numero", "")));
            a.setActionCorrective(String.valueOf(m.getOrDefault("action", "")));
            a.setDateBesoin(String.valueOf(m.getOrDefault("dateBesoin", "")));
            a.setResponsable(String.valueOf(m.getOrDefault("responsable", "")));
            a.setAnalyseCause(String.valueOf(m.getOrDefault("analyseCause", "")));
            a.setStatut(String.valueOf(m.getOrDefault("statut", "")));
            a.setDateCloture(String.valueOf(m.getOrDefault("dateCloture", "")));
            a.setEfficacite(String.valueOf(m.getOrDefault("efficacite", "")));
            entities.add(a);

            // Préparation Excel
            List<String> excelRow = Arrays.asList(
                    a.getNumero(), a.getActionCorrective(), */
/*... les autres champs ...*//*
 a.getStatut()
            );
            listForExcel.add(excelRow);
        }

        // Utilisation du bon repository pour sauvegarder
        repo.deleteAll();
        repo.saveAll(entities);

        // Synchro Excel ligne 8 (index 7)
        excelService.saveToExcel(FILE_PATH, listForExcel, 8, 0, 7);
    }


    // Dans ImprovementService.java

    public void initJournalFromExcel() throws IOException {
        System.out.println("📥 Initialisation du Journal d'Amélioration depuis Excel...");

        // 1. Lire les données (On commence à l'index 7 pour sauter le header à la ligne 7)
        // readGenericFromLine(chemin, nbColonnes, indexFeuille, ligneDebut)
        List<List<String>> data = excelService.readGenericFromLine(FILE_PATH, 8, 0, 7);

        if (data == null || data.isEmpty()) {
            System.out.println("⚠️ Le fichier Journal_Amelioration.xlsx est vide ou introuvable.");
            return;
        }

        List<ActionAmelioration> entities = new ArrayList<>();
        for (List<String> row : data) {
            // Ignorer les lignes totalement vides dans l'Excel
            if (row.get(0).isEmpty() && row.get(1).isEmpty()) continue;

            // Utiliser le mapper que nous avons créé pour convertir la ligne en entité
            entities.add(mapper.mapToEntity(row));
        }

        // 2. Sauvegarder dans la base
        repo.saveAll(entities);
        System.out.println("✅ Journal d'amélioration initialisé : " + entities.size() + " actions chargées.");
    }
}
*/


/*@Service
public class ImprovementService {
    @Autowired
    private ExcelService excelService;
    @Autowired private ImprovementRepository repo;
    @Autowired private ImprovementMapper mapper;

    private static final String FILE_PATH = "D:/Downoalds/spring-ad-auth/spring-ad-auth/Journal_Amelioration.xlsx";

    // Initialisation au démarrage
    public void initFromExcel() throws IOException {
        // On lit à partir de la ligne 8 (index 7) pour passer le header à la ligne 7
        List<List<String>> data = excelService.readGenericFromLine(FILE_PATH, 8, 0, 7);
        List<ActionAmelioration> entities = data.stream().map(mapper::mapToEntity).toList();
        repo.deleteAll();
        repo.saveAll(entities);
    }

    // Sauvegarde depuis le Web vers BD + Excel
    @Transactional
    public void saveAll(List<Map<String, Object>> data) throws IOException {
        // 1. Sauvegarde en Base de Données
        List<ActionAmelioration> entities = new ArrayList<>();
        List<List<String>> listForExcel = new ArrayList<>(); // TYPE FIXÉ : List de List

        for (Map<String, Object> m : data) {
            // Préparation de la ligne pour la BD
            ActionAmelioration a = new ActionAmelioration();
            a.setNumero(String.valueOf(m.getOrDefault("numero", "")));
            a.setActionCorrective(String.valueOf(m.getOrDefault("action", "")));
            a.setDateBesoin(String.valueOf(m.getOrDefault("dateBesoin", "")));
            a.setResponsable(String.valueOf(m.getOrDefault("responsable", "")));
            a.setAnalyseCause(String.valueOf(m.getOrDefault("analyseCause", "")));
            a.setStatut(String.valueOf(m.getOrDefault("statut", "")));
            a.setDateCloture(String.valueOf(m.getOrDefault("dateCloture", "")));
            a.setEfficacite(String.valueOf(m.getOrDefault("efficacite", "")));
            entities.add(a);

            // Préparation de la ligne pour l'EXCEL (Respect exact de l'ordre Col A à H)
            List<String> excelRow = new ArrayList<>();
            excelRow.add(a.getNumero());
            excelRow.add(a.getActionCorrective());
            excelRow.add(a.getDateBesoin());
            excelRow.add(a.getResponsable());
            excelRow.add(a.getAnalyseCause());
            excelRow.add(a.getStatut());
            excelRow.add(a.getDateCloture());
            excelRow.add(a.getEfficacite());

            listForExcel.add(excelRow);
        }

        // Sauvegarde DB
        repo.deleteAll();
        repo.saveAll(entities);

        // 2. Synchronisation Excel : Maintenant l'appel match parfaitement la signature
        excelService.saveToExcel(FILE_PATH, listForExcel, 8, 0, 7);
    }
}*/
