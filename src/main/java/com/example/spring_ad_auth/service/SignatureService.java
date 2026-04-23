package com.example.spring_ad_auth.service;

import com.example.spring_ad_auth.model.Signature;
import com.example.spring_ad_auth.repository.SignatureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class SignatureService {
    @Autowired
    private SignatureRepository signatureRepo;

    public void signer(String type, UUID id, String nom, String role, String username, String comm) {
        Signature s = new Signature();
        s.setEntityType(type);
        s.setEntityId(id);
        s.setNomSignataire(nom);
        s.setRoleSignataire(role);
        s.setUsername(username);
        s.setCommentaire(comm);
        signatureRepo.save(s);
    }
}