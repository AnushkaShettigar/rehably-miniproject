package com.rehably.api.repository;

import com.rehably.api.entity.Resource;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ResourceRepository extends JpaRepository<Resource, Long> {
    List<Resource> findAllByOrderByCategoryAscNameAsc();
}
