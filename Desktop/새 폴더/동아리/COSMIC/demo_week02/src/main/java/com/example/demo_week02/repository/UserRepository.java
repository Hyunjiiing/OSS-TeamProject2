package com.example.demo_week02.repository;

import com.example.demo_week02.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
