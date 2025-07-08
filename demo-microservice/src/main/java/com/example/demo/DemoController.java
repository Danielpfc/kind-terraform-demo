package com.example.demo;

import org.springframework.web.bind.annotation.*;

@RestController
public class DemoController {
    private final DemoRepository repo;

    public DemoController(DemoRepository repo) {
        this.repo = repo;
    }

    @PostMapping("/insert")
    public DemoEntity insert(@RequestParam String value) {
        DemoEntity entity = new DemoEntity();
        entity.setValue(value);
        return repo.save(entity);
    }
}
