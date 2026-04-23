package com.example.spring_ad_auth.repository;

import com.example.spring_ad_auth.model.NonConformite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface NonConformiteRepository extends JpaRepository<NonConformite, UUID> {}

