package com.example.spring_ad_auth.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class FileStorageService {

    @Value("${upload.path}")
    private String uploadPath;

    public String storeFile(MultipartFile file) throws IOException {
        // Créer le dossier s'il n'existe pas
        Path root = Paths.get(uploadPath);
        if (!Files.exists(root)) Files.createDirectories(root);

        // Nettoyer le nom du fichier et ajouter un timestamp pour éviter les doublons
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        Path target = root.resolve(fileName);

        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

        return fileName; // On retourne le nom pour le stocker en BD
    }
}