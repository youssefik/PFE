package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
public class SoATableService {

    @Autowired private ExcelService excelService;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private ControleRepository controleRepo;


    @Autowired
    private EntityManager entityManager; // Ajoutez ceci pour vider le cache


    public List<List<String>> getSoAAsTable() throws IOException {
        // Lit les données à partir de la ligne 5 de l'Excel
        List<List<String>> excelData = excelService.readAll();
        List<List<String>> output = new ArrayList<>();

        for (List<String> excelRow : excelData) {
            List<String> row = new ArrayList<>(excelRow);
            while (row.size() < 8) row.add(""); // Assurer 8 colonnes

            String code = row.get(0).trim();
            // Synchro avec les données fraîches de la base
            Optional<ElementSoA> soaOpt = soaRepo.findByControleCode(code);
            if (soaOpt.isPresent()) {
                ElementSoA soa = soaOpt.get();
                row.set(2, soa.isApplicable() ? "OUI" : "NON");
                row.set(3, soa.getJustification());
                row.set(4, soa.getDispositif());
                row.set(5, soa.getStatutMiseEnOeuvre());
                row.set(6, soa.getResponsable());
            }
            output.add(row);
        }
        return output;
    }

/*
    public List<List<String>> getSoAAsTable() throws IOException {
        List<List<String>> rawData = excelService.readAll();
        List<List<String>> output = new ArrayList<>();

        for (List<String> row : rawData) {
            // Ignorer les lignes totalement vides
            boolean isEmpty = row.stream().allMatch(String::isEmpty);
            if (isEmpty) continue;

            // Ignorer le titre principal du document "Déclaration d'applicabilité"
            if (row.get(0).equalsIgnoreCase("Déclaration d'applicabilité") ||
                    row.contains("Déclaration d'applicabilité")) {
                continue;
            }

            // Ignorer les lignes d'en-tête (Thème, Mesure de sécurité...)
            if (row.get(0).equalsIgnoreCase("Thème")) continue;

            output.add(row);
        }
        return output;
    }
*/

/*    public List<List<String>> getSoAAsTable() throws IOException {
        List<List<String>> rawExcel = excelService.readAll();
        List<List<String>> output = new ArrayList<>();

        // On commence la lecture à partir de la ligne des données réelles
        // Généralement i = 4 (après Titre, Headers, et premier titre de section)
        for (int i = 0; i < rawExcel.size(); i++) {
            List<String> excelRow = rawExcel.get(i);
            if (excelRow == null || excelRow.isEmpty()) continue;

            String firstCell = excelRow.get(0).trim();
            // Ignorer les lignes de titres de document (Déclaration d'applicabilité)
            if (firstCell.equalsIgnoreCase("Déclaration d'applicabilité") || firstCell.isEmpty() && i < 3) {
                continue;
            }

            List<String> row = new ArrayList<>(Collections.nCopies(9, "")); // 9 colonnes pour la gestion interne

            // On mappe les données de l'excel vers notre structure de tableau
            for (int col = 0; col < Math.min(excelRow.size(), 7); col++) {
                row.set(col, excelRow.get(col));
            }

            // SYNCHRONISATION AVEC LA BASE DE DONNÉES
            String code = firstCell;
            // Si c'est un vrai contrôle (ex: 5.1, 5.2...)
            if (code.matches("\\d+\\.\\d+.*")) {
                Optional<ElementSoA> soaOpt = soaRepo.findByControleCode(code);
                if (soaOpt.isPresent()) {
                    ElementSoA soa = soaOpt.get();
                    row.set(2, soa.isApplicable() ? "OUI" : "NON");
                    row.set(3, soa.getJustification());
                    row.set(4, soa.getDispositif()); // La colonne Preuve correspond au dispositif
                    row.set(5, soa.getStatutMiseEnOeuvre()); // OUI/NON ou EN COURS
                    row.set(6, soa.getResponsable());
                    row.set(8, soa.getCouleurStyle()); // Donnée cachée pour le style
                }
            }
            output.add(row);
        }
        return output;
    }*/

   /* @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {
        for (int i = 1; i < data.size(); i++) { // Sauter headers
            List<String> row = data.get(i);
            String code = row.get(0).trim();

            // Ne sauvegarder que les vrais contrôles
            if (!code.matches("\\d+\\.\\d+.*")) continue;

            Controle ctrl = controleRepo.findByCode(code);
            if (ctrl == null) continue;

            ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
            soa.setControle(ctrl);
            soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));
            soa.setJustification(row.get(3));
            soa.setDispositif(row.get(4));
            soa.setStatutMiseEnOeuvre(row.get(5));
            soa.setResponsable(row.get(6));
            if (row.size() > 8) soa.setCouleurStyle(row.get(8));

            soaRepo.save(soa);
        }
        // Mise à jour de l'excel après sauvegarde DB
        excelService.saveAll(data);
    }*/




    @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {
        // On enlève le header gris venant du Handsontable
        if (!data.isEmpty() && data.get(0).get(0).equalsIgnoreCase("Thème")) {
            data.remove(0);
        }

        // Logique de sauvegarde en base de données
        this.processDatabaseSaving(data);

        // Synchronisation immédiate vers le fichier Excel (Ligne 5+)
        excelService.saveAll(data);
    }



    // MÉTHODE 2 : Sauvegarde suite à un Import Excel (BD UNIQUEMENT)
    @Transactional
    public void saveTableToDBFromImport(List<List<String>> data) {
        this.processDatabaseSaving(data);
    }


    // Logique commune pour parser les données et sauver en BD
    private void processDatabaseSaving(List<List<String>> data) {
        for (List<String> row : data) {
            String code = (row.get(0) != null) ? row.get(0).trim() : "";
            if (code.isEmpty() || !code.contains(".")) continue;

            Controle ctrl = controleRepo.findByCode(code);
            if (ctrl == null) {
                ctrl = new Controle();
                ctrl.setCode(code);
                ctrl.setTitre(row.get(1));
                ctrl.setDomaine("Automatique");
                ctrl = controleRepo.save(ctrl);
            }

            ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
            soa.setControle(ctrl);
            soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));
            soa.setJustification(row.size() > 3 ? row.get(3) : "");
            soa.setDispositif(row.size() > 4 ? row.get(4) : "");
            soa.setStatutMiseEnOeuvre(row.size() > 5 ? row.get(5) : "");
            soa.setResponsable(row.size() > 6 ? row.get(6) : "");
            if (row.size() > 7) soa.setCouleurStyle(row.get(7));

            soaRepo.save(soa);
        }
    }


   /* @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {
        if (data == null || data.isEmpty()) return;

        // 1. NETTOYAGE RIGOUREUX DU HEADER JS
        // On retire la ligne d'en-tête (Thème, Mesure...) si elle est présente au début
        // On utilise trim() et ignoreCase pour être sûr
        if (data.get(0).get(0).trim().equalsIgnoreCase("Thème") ||
                data.get(0).get(0).trim().equalsIgnoreCase("Code")) {
            data.remove(0);
            System.out.println(">>> Header 'Thème' supprimé de la liste data.");
        }

        // 2. Sauvegarde en Base de Données
        for (List<String> row : data) {
            String code = (row.get(0) != null) ? row.get(0).trim() : "";

            // On ne traite en BD que les lignes avec un point (5.1, A.5.1, etc.)
            if (!code.isEmpty() && code.contains(".")) {
                Controle ctrl = controleRepo.findByCode(code);
                if (ctrl == null) {
                    // Création si nouveau contrôle (votre logique actuelle)
                    ctrl = new Controle();
                    ctrl.setCode(code);
                    ctrl.setTitre(row.get(1));
                    ctrl.setDomaine("Thème " + code.split("\\.")[0]);
                    ctrl = controleRepo.save(ctrl);
                }

                ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
                soa.setControle(ctrl);
                soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));
                soa.setJustification(row.get(3));
                soa.setDispositif(row.get(4));
                soa.setStatutMiseEnOeuvre(row.get(5));
                soa.setResponsable(row.get(6));
                if (row.size() > 7) soa.setCouleurStyle(row.get(7));

                soaRepo.save(soa);
            }
        }

        // 3. Synchronisation Excel (data ne contient plus le header gris)
        excelService.saveAll(data);
    }*/


   /* @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {

        // IMPORTANT : On retire les headers du début (index 0)
        // pour ne pas les écrire DANS le contenu de l'excel
        if (data.size() > 0 && data.get(0).get(0).equalsIgnoreCase("Thème")) {
            data.remove(0);
        }

        // 1. D'abord on enregistre dans la base de données
        // i=1 pour sauter la ligne d'en-tête (colHeaders)
        for (List<String> row : data) {

            String libelle = row.get(1) != null ? row.get(1).trim() : "";

            // Ignorer les lignes de titres de chapitres (ex: "5, MESURES...")
            // qui n'ont pas de point dans le code.
            String code = row.get(0).trim();
            if (code.isEmpty() || !code.contains(".")) continue; // Sauver uniquement les contrôles (5.1, etc.)


            // Chercher le contrôle par son code (5.1, 5.2, etc.)
            Controle ctrl = controleRepo.findByCode(code);

            // --- ACTION SI C'EST UNE NOUVELLE LIGNE ---
            if (ctrl == null) {
                System.out.println(">>> Création d'un nouveau contrôle en base : " + code);
                ctrl = new Controle();
                ctrl.setCode(code);
                ctrl.setTitre(libelle);
                // On peut essayer de deviner le domaine par le premier chiffre
                ctrl.setDomaine("Thème " + code.split("\\.")[0]);
                ctrl = controleRepo.save(ctrl); // On sauvegarde le nouveau contrôle d'abord
            }

            // Récupérer ou créer l'élément de conformité lié
            ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
            soa.setControle(ctrl);

            // On mappe les colonnes selon la structure de votre image (0:code, 1:mesure, 2:applic, 3:justif, 4:preuve, 5:statut, 6:resp)
            soa.setApplicable("OUI".equalsIgnoreCase(row.get(2)));
            soa.setJustification(row.get(3));
            soa.setDispositif(row.get(4));
            soa.setStatutMiseEnOeuvre(row.get(5));
            soa.setResponsable(row.get(6));

            if (row.size() > 7) {
                soa.setCouleurStyle(row.get(7)); // StyleData à l'index 7 (car 8 colonnes totales)
            }

            soaRepo.save(soa);
        }

        // 2. Ensuite on synchronise le fichier Excel avec TOUTES les données (Titres inclus)
        excelService.saveAll(data);
    }*/
}



/*@Service
public class SoATableService {

    @Autowired private ExcelService excelService;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private ControleRepository controleRepo;

    @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {
        System.out.println("--- DÉBUT DE LA SAUVEGARDE GÉNÉRALE ---");

        for (int i = 1; i < data.size(); i++) { // i=1 pour sauter l'en-tête
            List<String> row = data.get(i);
            if (row.size() < 2) continue;

            String code = row.get(1) != null ? row.get(1).toString().replaceAll("[\\s\\u00A0]+", "").trim() : "";
            if (code.isEmpty() || code.equalsIgnoreCase("Contrôle") || code.equalsIgnoreCase("Code")) continue;

            if (code.endsWith(".0")) code = code.substring(0, code.length() - 2);

            Controle ctrl = controleRepo.findByCode(code);
            if (ctrl == null) {
                ctrl = new Controle();
                ctrl.setCode(code);
                ctrl.setTitre(row.get(2));
                ctrl.setDomaine(row.get(0));
                ctrl = controleRepo.save(ctrl);
            }

            ElementSoA soa = soaRepo.findByControleId(ctrl.getId()).orElse(new ElementSoA());
            soa.setControle(ctrl);

            // --- LECTURE DES COLONNES EXCEL VERS LA BD ---

            // 1. Applicabilité (Index 3)
            String appValue = row.get(3) != null ? row.get(3).trim() : "";
            soa.setApplicable(appValue.equalsIgnoreCase("Oui"));

            // 2. Justification (Index 4)
            soa.setJustification(row.size() > 4 ? row.get(4) : "");

            // 3. FIX : "En place ?" (Index 5)
            // C'est cette ligne qui manquait dans votre code !
            String enPlaceValue = (row.size() > 5 && row.get(5) != null) ? row.get(5).trim() : "Non";
            soa.setStatutMiseEnOeuvre(enPlaceValue);

            // 4. Optionnel : Dispositif (Index 6) et Responsable (Index 7)
            // Si vous avez ajouté les champs dans le modèle ElementSoA :
            *//*
            soa.setDispositif(row.size() > 6 ? row.get(6) : "");
            soa.setResponsable(row.size() > 7 ? row.get(7) : "");
            *//*
            soa.setDispositif(row.size() > 6 ? row.get(6) : "");
            soa.setResponsable(row.size() > 7 ? row.get(7) : "");
            // 5. Style (Index 8)
            if (row.size() > 8 && row.get(8) != null && !row.get(8).trim().isEmpty()) {
                soa.setCouleurStyle(row.get(8).trim());
            }

            soaRepo.save(soa);
        }
        excelService.saveAll(data);
        System.out.println("--- SAUVEGARDE TERMINÉE ---");
    }

    public List<List<String>> getSoAAsTable() throws IOException {
        List<List<String>> excelData = excelService.readAll();
        List<List<String>> output = new ArrayList<>();

        for (List<String> excelRow : excelData) {
            List<String> row = new ArrayList<>(excelRow);
            // Assurer d'avoir 9 colonnes pour Handsontable (0 à 8)
            while (row.size() < 9) row.add("");

            String code = row.get(1) != null ? row.get(1).trim() : "";
            if (code.endsWith(".0")) code = code.substring(0, code.length() - 2);

            Optional<ElementSoA> soaOpt = soaRepo.findByControleCode(code);

            if (soaOpt.isPresent()) {
                ElementSoA soa = soaOpt.get();
                // Synchroniser l'affichage avec la BD
                row.set(3, soa.isApplicable() ? "Oui" : "Non");
                row.set(4, soa.getJustification());
                row.set(5, soa.getStatutMiseEnOeuvre() != null ? soa.getStatutMiseEnOeuvre() : "Non");
                row.set(6, soa.getDispositif());
                row.set(7, soa.getResponsable());
                row.set(8, soa.getCouleurStyle() != null ? soa.getCouleurStyle() : "");
            }
            output.add(row);
        }
        return output;
    }
}*/

/*
package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Controle;
import com.example.spring_ad_auth.model.ElementSoA;
import com.example.spring_ad_auth.repository.ControleRepository;
import com.example.spring_ad_auth.repository.ElementSoARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class SoATableService {

    @Autowired private ExcelService excelService;
    @Autowired private ElementSoARepository soaRepo;
    @Autowired private ControleRepository controleRepo;

    @Transactional
    public void saveTableToDB(List<List<String>> data) throws IOException {
        // 1. Sauvegarde en Base de Données (Données + Couleurs dans la 9ème colonne)
        for (int i = 1; i < data.size(); i++) {
            List<String> row = data.get(i);
            if (row.size() < 2) continue;

            String code = row.get(1).trim();
            if (code.isEmpty() || code.equalsIgnoreCase("Contrôle")) continue;

            Controle ctrl = controleRepo.findByCode(code);
            if (ctrl != null) {
                ElementSoA soa = soaRepo.findByControleId(ctrl.getId())
                        .orElse(new ElementSoA());
                soa.setControle(ctrl);
                soa.setApplicable("Oui".equalsIgnoreCase(row.get(3)));
                soa.setJustification(row.get(4));

                // Sauvegarde du style uniquement en BD (9ème colonne / index 8)
                if (row.size() > 8) {
                    soa.setCouleurStyle(row.get(8));
                }
                soaRepo.save(soa);
            }
        }

        // 2. Sauvegarde dans le fichier Excel (ExcelService filtrera pour n'avoir que 8 colonnes)
        excelService.saveAll(data);
    }

    public List<List<String>> getSoAAsTable() throws IOException {
        List<List<String>> rows = excelService.readAll(); // Lit 8 colonnes
        for (List<String> row : rows) {
            if (row.size() > 1) {
                String code = row.get(1).trim();
                Optional<ElementSoA> soaOpt = soaRepo.findByControleCode(code);
                // Injecte la couleur depuis la BD pour l'affichage (9ème colonne)
                row.add(soaOpt.isPresent() ? soaOpt.get().getCouleurStyle() : "");
            }
        }
        return rows;
    }
}*/
